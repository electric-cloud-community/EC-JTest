
# Data that drives the create step picker registration for this plugin.
my %runJtest = (
    label       => "JTest - Run JTest",
    procedure   => "runJtest",
    description => "Integrates JTest Tool into Electric Commander",
    category    => "Test"
);

$batch->deleteProperty("/server/ec_customEditors/pickerStep/Jtest");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/JTest - Run JTest");

@::createStepPickerSteps = (\%runJtest);
