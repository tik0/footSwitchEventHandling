#include <linux/input.h>
#include <iostream>

// Handle program options
#include <boost/program_options.hpp>

// File operation
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

void printEvent(input_event evt);

int main(int argc, char* argv[]) {

  // Program options
  std::string eventDevice("");
  std::string cmdP("");
  std::string cmdR("");
  bool debug = false;

  // Handle program options
  namespace po = boost::program_options;
  po::options_description options("Allowed options");
  options.add_options()("help,h", "Display a help message.")
  ("debug", po::bool_switch(&debug)->default_value(false), "Enable debug outputs")
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
  if ((eventDevice.empty() || (cmdP.empty() && cmdR.empty())) && !debug) {
    std::cout << options << "\n";
    exit(1);
  }

  // Open the event device
   int fd=0;
   const size_t eventSize = sizeof(input_event);
   input_event buffer;
   ssize_t nbytes=0;

   fd = open(eventDevice.c_str(), O_RDONLY);
   if ( fd < 0 ) {
     std::cout << "Unable to open device: " << eventDevice << std::endl;
     return -1;
   }

  //read data from the descriptors in a loop. Terminate
  //when an error occurs or when either pipe has been closed
  while (true) {
    nbytes = read(fd, (void*) &buffer, eventSize);
    if( nbytes < 0 ) { // a negative value means a device failure
      std::cout << "Device failure" << std::endl;
      return -1;
    } else if (!nbytes) { // Device is closed
      std::cout << "Device is closed" << std::endl;
      return -1;
    } else if ( nbytes != eventSize ) { // Unexpected number of bytes
      std::cout << "Number of received bytes unexpected: "
                << nbytes << " (rec) vs. "
                << eventSize << " (exp)" << std::endl;
    } else { // process the buffer
      if (debug) {
        std::cout << "---------- DEBUG START: input_event ----------" << std::endl;
        printEvent(buffer);
        std::cout << "---------- DEBUG END: input_event ----------" << std::endl;
      }


    }
  }
}

void printEvent(input_event evt) {
  // Get the value
  std::string valueStr("");
  switch(evt.value) {
    case(EV_SYN)      : valueStr = "EV_SYN"; break;
    case(EV_KEY)      : valueStr = "EV_KEY"; break;
    case(EV_REL)      : valueStr = "EV_REL"; break;
    case(EV_ABS)      : valueStr = "EV_ABS"; break;
    case(EV_MSC)      : valueStr = "EV_MSC"; break;
    case(EV_SW )      : valueStr = "EV_SW"; break;
    case(EV_LED)      : valueStr = "EV_LED"; break;
    case(EV_SND)      : valueStr = "EV_SND"; break;
    case(EV_REP)      : valueStr = "EV_REP"; break;
    case(EV_FF )      : valueStr = "EV_FF"; break;
    case(EV_PWR)      : valueStr = "EV_PWR"; break;
    case(EV_FF_STATUS): valueStr = "EV_FF_STATUS"; break;
    case(EV_MAX)      : valueStr = "EV_MAX"; break;
    case(EV_CNT)      : valueStr = "EV_CNT"; break;
    default           : valueStr = "NO STRING FOUND"; break;
  }


  std::cout <<
      "time.tv_sec: " << evt.time.tv_sec << std::endl <<
      "time.tv_usec: " << evt.time.tv_usec << std::endl <<
      "type: " << evt.type << std::endl <<
      "code: " << evt.code << std::endl <<
      "value: " << evt.value << " (" << valueStr << ")" << std::endl <<
  std::flush;
}
