# -------------------------------------------------------------------------
# # Purpose
#    Main programming file for JTest Plugin
#
# JTest Version
#    1.0.0.0
#
# Date
#    01/11/2010
#
# Engineer
#   Brian Nelson
#
# Copyright (c) 2010 Electric Cloud, Inc.
# All rights reserved
# -------------------------------------------------------------------------


# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------
use warnings;
use strict; 
$|=1;
use ElectricCommander;
# -------------------------------------------------------------------------
# Constants
# -------------------------------------------------------------------------
use constant {
	GTP_VALUE => 'gtp',
	PTP_VALUE => 'ptp',
	CTP_VALUE => 'ctp'
};

# -------------------------------------------------------------------------
# Variables
# -------------------------------------------------------------------------
$::gDirectory=q{$[directory]};
$::gJtestFileType = "$[jtestFileType]";
$::gReportFile = "$[reportFile]";
$::gRulesDirectory = q($[rulesDirectory]);
$::jtestFileName = "$[jtestFileName]";
$::gAdditionalOptions = q{$[additionalOptions]};
########################################################################
# main - contains the whole process to be done by the plugin, it builds 
#        the command line, sets the properties and the working directory
#
# Arguments:
#   -none
#
# Returns:
#   -nothing
#
########################################################################
sub main() {
     # create args array
    my @args = ();
    
    #properties' map
    my %props;
    
    #executable to use
    my $executable ='jtestgui -nogui -nologo';
    
    #insert program to invoke
    push(@args, $executable);

    #type of file to execute, it could be gtp ctp ptp
    
    if($::gJtestFileType  && $::gJtestFileType ne "" && $::gJtestFileType eq GTP_VALUE ) {
         if($::jtestFileName=~ m/(.+)\.gtp/){
            push(@args,"-gtp $::jtestFileName");
         }
        else {
            cpf_error("Invalid file type,use a file with a gtp extension");
        }
    }
    elsif($::gJtestFileType  && $::gJtestFileType ne "" && $::gJtestFileType eq PTP_VALUE ) {
         if($::jtestFileName=~ m/(.+)\.ptp/){
            push(@args,"-ptp $::jtestFileName");
         }
         else {
            cpf_error("Invalid file type,use a file with a ptp extension");
        }
    }
    elsif($::gJtestFileType  && $::gJtestFileType ne "" && $::gJtestFileType eq CTP_VALUE ) {
         if($::jtestFileName=~ m/(.+)\.ctp/){
            push(@args,"-ctp $::jtestFileName");
         }
        else {
            cpf_error("Invalid file type,use a file with a ctp extension");
        }
    }
    # Generate report in a specified file type xml,ascii,html
    if($::gReportFile   && $::gReportFile ne "") {
       
        if($::gReportFile=~ m/(.+)\.xml/){
            push(@args,"-report_xml $::gReportFile");
        }
         elsif($::gReportFile=~ m/(.+)\.html/){
            push(@args,"-report_html $::gReportFile");
        }
        elsif($::gReportFile=~ m/(.+)\.txt/ ||$::gReportFile=~ m/(.+)\.tex/ ||$::gReportFile=~ m/(.+)\.rtf/ || $::gReportFile=~ m/(.+)\.ps/){
            push(@args,"-report_ascii $::gReportFile");
        }
        else {
            cpf_error("Invalid file type report extension");
        }
    }
    #Use <rulesdir> as the RuleWizard rules directory
    if($::gRulesDirectory   && $::gRulesDirectory ne "") {
        push(@args,"-rulesdir $::gRulesDirectory");
    }
    
    #Additional options can be added to the jtest command
    if($::gAdditionalOptions  && $::gAdditionalOptions  ne "") {
        foreach my $command (split(' ',$::gAdditionalOptions)) {
            push(@args, $command);
        }
    }
    
    $props{'workingDir'} = $::gDirectory;
    $props{'commandLine'} = createCommandLine(\@args);
    
    setProperties(\%props);
}

########################################################################
# createCommandLine - creates the command line for the invocation
# of the program to be executed.
#
# Arguments:
#   -arr: array containing the command name and the arguments entered by 
#         the user in the UI
#
# Returns:
#   -the command line to be executed by the plugin
#
########################################################################
sub createCommandLine($) {

    my ($arr) = @_;

    my $commandName = @$arr[0];

    my $command = $commandName;

    shift(@$arr);

    foreach my $elem (@$arr) {
        $command .= " $elem";
    }
    return $command;
}

########################################################################
# setProperties - set a group of properties into the Electric Commander
#
# Arguments:
#   -propHash: hash containing the ID and the value of the properties 
#              to be written into the Electric Commander
#
# Returns:
#   -nothing
#
########################################################################
sub setProperties($) {

    my ($propHash) = @_;

    # get an EC object
    my $ec = new ElectricCommander();
    $ec->abortOnError(0);

    foreach my $key (keys % $propHash) {
        my $val = $propHash->{$key};
        $ec->setProperty("/myCall/$key", $val);
    }
}
sub cpf_error() {
    my ($message) = @_;
    chomp($message);
    $message =~ s/\.$//;
    $message = "ERROR: $message.\n";
    
    print(STDERR $message);
    
    exit 1;
}
main();
