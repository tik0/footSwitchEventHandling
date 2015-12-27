#include <linux/input.h>
#include <iostream>
#include <boost/program_options.hpp>

int main(int argc, char* argv[]) {

  std::string eventDevice("");
  std::string cmdP("");
  std::string cmdR("");

  // Handle program options
  namespace po = boost::program_options;
  po::options_description options("Allowed options");
  options.add_options()("help,h", "Display a help message.")
  ("eventDevice,e", po::value<std::string>(&eventDevice), "Event device to read from: e.g. /dev/input/event0")
  ("cmdP,p", po::value<std::string>(&cmdP), "Command to execute if the switch is pressed: e.g. /opt/myPressProgram.sh")
  ("cmdR,r", po::value<std::string>(&cmdR), "Command to execute if the switch is pressed: e.g. /opt/myReleaseProgram.sh");
  // allow to give the value as a positional argument
  po::positional_options_description p_description;
  p_description.add("value", 1);

  po::variables_map vm;
  po::store(po::command_line_parser(argc, argv).options(options).positional(p_description).run(), vm);

  // first, process the help option
  if (vm.count("help")) {
    std::cout << options << "\n";
    exit(1);
  }

  // afterwards, let program options handle argument errors
  po::notify(vm);

  // Display the help, if the arguments are not set corret
  if (eventDevice.empty() || (cmdP.empty() && cmdR.empty())) {
    std::cout << options << "\n";
    exit(1);
  }
}
