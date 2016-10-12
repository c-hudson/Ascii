#!/usr/bin/perl

#
# add_last_info
#
#    Add details about when a user last did something.
#
sub add_last_info
{
   my ($cmd,$arg) = @_;

   # create structure to hold last info if needed
   $$user{last} = {} if(!defined $$user{last});

   # populate last hash with the info
   my $last = $$user{last};
   $$last{time} = time();
   $$last{cmd} = $cmd;
   $$last{arg} = $arg;
}

sub trim
{
   my $txt = shift;

   $txt =~ s/^\s+|\s+$//g;
   return $txt;
}

# ste_type
#
# -- 1   close connection as soon as possible
# -- 2   show banned.txt
# -- 3   registration
# -- 4   open
#
sub add_site_restriction 
{
   my $sock = shift;

   my $hash=one($db,
                "select ifnull(min(ste_type),4) ste_type" .
                "  from site ".
                " where (lower(?) like lower(ste_pattern) ".
                "    or lower(?) like lower(ste_pattern))" .
                "   and ifnull(ste_end_date,now()) >= now()",
                $$sock{ip},
                $$sock{hostname}
               );
   $$sock{site_restriction} = $$hash{ste_type};
}

#
# mush_command
#    Search and run attributes that match the command that was typed in.
sub mush_command
{
   my ($data,$cmd) = @_;
   my ($match,$count)=(0,0);
     
   # look for any attributes in the same room as the player
   for my $hash (@{sql("select obj.obj_id, " .
                       "       substr(atr_value,2,instr(atr_value,':')-2) cmd,".
                       "       substr(atr_value,instr(atr_value,':')+1) txt ".
                       "  from object obj, attribute atr, content con " .
                       " where obj.obj_id = atr.obj_id " .
                       "   and obj.obj_id = con.obj_id " .
                       "   and ? like  " .
                "replace(substr(atr_value,1,instr(atr_value,':')-1),'*','%')" .
                       "   and con.con_source_id in ( ?, ? ) ",
                       "\$" . lc($cmd),
                       loc($user),
                       $$user{obj_id}
                      )
                }) {
      # run up to  150 commands
      #
      # improvements:
      #     1. split commands apart better?
      #     2. shove jobs into a queue to run later and nicer on mush
      #     3. Remove arbitrary 150 command limit if needed?
      #


#      printf("# TXT: '$hash'\n");
#      printf("# TXT: '%s'\n",print_var($hash));
      ($$user{1},$$user{2},$$user{3},$$user{4},$$user{5},
       $$user{6},$$user{7},$$user{8},$$user{9}) =
         (undef,undef,undef,undef,undef,undef,undef,undef);
      if($$hash{cmd} ne $cmd) {
         $$hash{cmd} =~ s/\*/\(.*\)/g;
         if($cmd =~ /^$$hash{cmd}$/) {
            ($$user{1},$$user{2},$$user{3},$$user{4},$$user{5},
             $$user{6},$$user{7},$$user{8},$$user{9}) =
            ($1,$2,$3,$4,$5,$6,$7,$8,$9);
         }
      }
      while($$hash{txt} ne undef && $count++ < 150) {
         # look for unescaped semi-colons to split apart lines
         if($$hash{txt} =~ /^(.*?)(?<!(?<!\\)\\);/) {
            force($hash,trim($1 . " " . $2));
            $$hash{txt} = trim($');
         } else {                  # process all text if no semi-colon found
            force($hash,trim($$hash{txt}));
            $$hash{txt} = undef;
         }
     }
     $match=1;                                   # signal mush command found
   }
   return $match;
}

#
# lookup_command
#    Try to find a internal command, exit, or mush command to run.
#
sub lookup_command
{
   my ($hash,$cmd,$txt,$type) = (@_[0],lc(@_[1]),@_[2],@_[3]);
   my $match;

   if(defined $$hash{$cmd}) {                       # match on internal cmd
      return ($cmd,trim($txt));
   } elsif(defined $$hash{substr($cmd,0,1)} &&             # one letter cmd
           (defined @{$$hash{substr($cmd,0,1)}}{nsp} ||  # w/wo space after
            substr($cmd,1,1) eq " " ||                            # command
            length($cmd) == 1
           )
          ) {
      return (substr($cmd,0,1),trim(substr(@_[1],1) . $txt));
   } else {                                     # match on partial cmd name
      $txt =~ s/^\s+|\s+$//g;
      for my $key (keys %$hash) {              #  find partial unique match
         if(substr($key,0,length($cmd)) eq $cmd) {
            if($match eq undef) {
               $match = $key;
            } else {
               $match = undef;
               last;
            }
         }
      }
      if($match ne undef) {                                  # found match
         return ($match,trim($txt));
      } elsif($txt =~ /^\s*$/ && $type && locate_exit($cmd)) {  # exit match
         return ("go",$cmd);
      } elsif(mush_command($hash,trim($cmd . " " . $txt))) { # mush command
         return ("\@\@",$cmd . " " . $txt);    
      } else {                                                  # no match
         return ('huh',trim($txt));
      }
   }
}


#
# server_process_line
#
#    A line of text has finally come in, see if its a valid command and
#    run it. Commands differ for if the user is connected or not.
#    This is also where some server crashes are detected.
#
sub server_process_line
{

   my ($hash,$input) = @_;

#   if($input !~ /^\s*$/) {
#      printf("#%s# '%s'\n",((defined $$hash{obj_id}) ? obj_name($hash) : "?"),
#      $input);
#   }
   my $data = @connected{$$hash{sock}};

   if($$data{raw}) {
     echo_room($$data{owner},"%s",$input);
   } else {
      eval {                                                  # catch errors
         if($input =~ /^\s*([^ ]+)/) {
            $user = $hash;
            if(loggedin($hash) || hasflag($hash,"OBJECT")) {
               my ($cmd,$arg) = lookup_command(\%command,$1,$',1);
               &{@{@command{$cmd}}{fun}}($arg);                  # invoke cmd
               add_last_info($cmd,$');                                #logit
            } else {
               my ($cmd,$arg) = lookup_command(\%offline,$1,$',0);
               &{@offline{$cmd}}($arg);                          # invoke cmd
            }
         }
      };

      if($@) {                                # oops., you sunk my battle ship
         printf("# %s crashed the server with: %s\n%s",name($hash),$_[1],$@); 
         printf("LastSQL: '%s'\n",@info{sql_last});
         printf("         '%s'\n",@info{sql_last_args});
         rollback($db);
   
         my $msg = sprintf("%s crashed the server with: %s",name($hash),$_[1]);
         echo($hash,"%s",$msg);
         if($msg ne $$user{crash}) {
           echo_room($hash,"%s",$msg);
            $$user{crash} = $msg;
         }
         delete @$hash{buf};
      }
   }
}


#
# server_hostname
#    lookup the hostname based upon the ip address
#
sub server_hostname
{
   my $sock = shift;
   my $ip = $sock->peerhost;                           # contains ip address

   my $name = gethostbyaddr(inet_aton($ip),AF_INET) ||
      return $ip;                                 # return lookedup hostname
   return $name;                         # or last resort, return ip address
}


#
# server_handle_sockets
#    Open Handle all incoming I/O and try to sleep frequently enough
#    so that all of the cpu is not being used up.
#
sub server_handle_sockets
{
   eval {
   # wait for IO or 1 second
   my ($sockets) = IO::Select->select($readable,undef,undef,2);
   my $buf;

   if(!defined @info{server_start} || @info{server_start} =~ /^\s*$/) {
      @info{server_start} = time();
   }

   # all processing happens when there is I/O but certain things will
   # have to happen when it should instead of when I/O happened. Add
   # code here when whatever that is figured out.
   # 
   # server_tick()?

   # process any IO
   foreach my $s (@$sockets) {         # loop through active sockets [if any]
       if($s == $listener) {                                 # new connection
          my $new = $listener->accept();                          # accept it
          if($new) {                                          # valid connect
             $readable->add($new);                 # add 2 watch list 4 input
             my $hash = { sock => $new,               # store connect details
                          hostname => server_hostname($new),
                          ip => $new->peerhost,
                          loggedin => 0,
                          raw => 0
                        };
             add_site_restriction($hash);
             @connected{$new} = $hash;

             printf("# Connect from: %s\n",$$hash{hostname});
             if($$hash{site_restriction} <= 2) {                    # banned
                printf("   BANNED   [Booted]\n");
                if($$hash{site_restriction} == 2) {
                   printf($new "%s",getfile("badsite.txt"));
                }
                server_disconnect(@{@connected{$new}}{sock});
             } else {
                printf($new "%s",getfile("login.txt"));   #  show login
             }
          }                                                        
       } elsif(sysread($s,$buf,1024) <= 0) {           # socket disconnected
          server_disconnect($s);
       } else {                                           # socket has input
          $buf =~ s/\r//g;                                  # remove returns
          $buf =~ tr/\x80-\xFF//d;
          @{@connected{$s}}{buf} .= $buf;                      # store input
          
                                                        # breakapart by line
          while(defined @connected{$s} && @{@connected{$s}}{buf} =~ /\n/) {
             @{@connected{$s}}{buf} = $';                 # store left overs
             server_process_line(@connected{$s},$`);          # process line
          }
       }
    }
    };
      if($@){
         printf("Server Crashed, minimal details [main_loop]\n");
         printf("LastSQL: '%s'\n",@info{sql_last});
         printf("         '%s'\n",@info{sql_last_args});
         printf("%s\n---[end]-------\n",$@);
      }

}

#
# server_disconnect
#    Either the user has QUIT or disconnected, so handle the disconnect
#    approprately.
#
sub server_disconnect
{
   my $id = shift;

   # notify connected users of disconnect
   if(defined @connected{$id}) {
      my $hash = @connected{$id};

      if(defined $$hash{raw} && $$hash{raw} == 1) {            # MUSH Socket
         echo_room($$hash{owner},"[ Connection closed ]");
         sql($db,                             # delete socket table row
             "delete from socket " .
             " where sck_socket = ? ",
             $id
            );
         commit($db);
      } elsif(defined $$hash{connect_time}) {                # Player Socket
         echo_room($hash,"%s has disconnected.",name($hash));

         my $key = connected_user($hash);
         delete @{@connected_user{$$hash{obj_id}}}{$key};
         if(scalar keys %{@connected_user{$$hash{obj_id}}} == 0) {
            delete @connected_user{$$hash{obj_id}};
         }

         my $sck_id = one_val($db,                           # find socket id
                              "select sck_id value " .
                              "  from socket " .
                              " where sck_socket = ?" ,
                              $id
                             );

         if($sck_id ne undef) {
             sql($db,                                  # log disconnect time
                 "update socket_history " .
                 "   set skh_end_time = now() " .
                 " where sck_id = ? ",
                  $sck_id
                );
   
             sql($db,                             # delete socket table row
                 "delete from socket " .
                 " where sck_id = ? ",
                 $sck_id
                );
             commit($db);
         }
      }
   }

   # remove user out of the loop
   $readable->remove($id);
   $id->close;
   delete @connected{$id};
}

#
# server_start
#
#    Start listening on the specified port for new connections.
#
sub server_start
{
   my $port = shift;
   printf("Listening on port $port\n");

   $listener = IO::Socket::INET->new(LocalPort=>$port,Listen=>1,Reuse=>1);
   $readable = IO::Select->new();          # setup socket polling routines
   $readable->add($listener);

   # main loop;
   while(1) {
      eval {
         server_handle_sockets();
      };
      if($@){
         printf("Server Crashed, minimal details [main_loop]\n");
         printf("LastSQL: '%s'\n",@info{sql_last});
         printf("         '%s'\n",@info{sql_last_args});
         printf("%s\n---[end]-------\n",$@);
      }
   }
}

1;
