use ElectricCommander;

push (@::gMatchers,
  {
        id =>          "totalTime",
        pattern =>     q{.+Total time: (\d+)},
        action =>           q{
                              
                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');

                              $desc .= "Total Maven Time : $1 seconds";
                                
                               setProperty("summary", $desc . "\n");
                              
                             },
  },
);

push (@::gMatchers,
  {
        id =>          "finishedAt",
        pattern =>     q{.+Finished at: (.+)},
        action =>           q{
                              
                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');

                              $desc .= "Finished at: $1";
                                
                               setProperty("summary", $desc . "\n");
                              
                             },
  },
);


push (@::gMatchers,
  {
        id =>          "finalMemory",
        pattern =>     q{.+Final Memory: (.+)},
        action =>           q{
                              
                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');

                              $desc .= "Final Memory: $1";
                                
                               setProperty("summary", $desc . "\n");
                              
                             },
  },
);


push (@::gMatchers,
  {
        id =>          "sourceDirectories",
        pattern =>     q{.+Source directories: (.+)},
        action =>           q{
                              
                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');

                              $desc .= "Source Directories: $1";
                                
                               setProperty("summary", $desc . "\n");
                              
                             },
  },
);

push (@::gMatchers,
  {
        id =>          "classpathDirectory",
        pattern =>     q{.+Classpath: (.+)},
        action =>           q{
                              
                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');

                              $desc .= "Classpath: $1";
                                
                               setProperty("summary", $desc . "\n");
                              
                             },
  },
);


push (@::gMatchers,
  {
        id =>          "InvalidTask",
        pattern =>     q{\[INFO]\ (Invalid task .+)},
        action =>           q{
                              
                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');
       

                              $desc .= "ERROR: $1";
                                
                               setProperty("summary", $desc . "\n");
                              
                             },
  },
);


push (@::gMatchers,
  {
        id =>          "CommandLineOptionError",
        pattern =>     q{(Unable to parse command line options:.+)},
        action =>           q{
                              my $desc = ((defined $::gProperties{"summary"}) ? $::gProperties{"summary"} : '');
       
                              $desc .= "ERROR: $1";
                                
                               setProperty("summary", $desc . "\n");
                              
                             },
  },
);


push (@::gMatchers,
    {
        id =>               "mavenSummary",
        pattern =>          q{Tests run: (\d+), Failures: (\d+), Errors: (\d+), Skipped: (\d+), Time elapsed: (\d+)},
        action =>           q{incValue("tests", $1);
                                    if (($2 + $3) > 0) {
                                        incValue("errors", $2 + $3);
                                        my $start = 0;
                                        if (logLine($::gCurrentLine-1) =~ m/Running/) {
                                            $start = -1;
                                        }
                                        diagnostic("", "error", $start);
                                    }
                            
        },                                      
    },
    
);

push (@::gMatchers,
	{
		id => "buildFailureError",
		pattern => q{^\s*[ERROR] BUILD },
		action => q{incValue("errors", 1); diagnostic("", "error", 0, forwardTo(q{^\s*[INFO] ----}, 2))},
	},
);


    