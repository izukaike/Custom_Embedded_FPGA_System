
#include <iostream>
#include <windows.h>
#include <cstdint>  // For uint8_t
#include <chrono>
#include <thread>  // For sleep_for
#include <bitset>  // For std::bitset
#include <fstream>

class UART {
private:
    HANDLE hSerial;

public:
    UART(const char* portName, int baudRate) {
        hSerial = CreateFileA(
            portName,
            GENERIC_READ | GENERIC_WRITE,
            0,
            NULL,
            OPEN_EXISTING,
            0,
            NULL
        );

        if (hSerial == INVALID_HANDLE_VALUE) {
            std::cerr << "Error: Unable to open the UART port!" << std::endl;
            exit(EXIT_FAILURE);
        }

        DCB dcbSerialParams = {0};
        dcbSerialParams.DCBlength = sizeof(dcbSerialParams);

        if (!GetCommState(hSerial, &dcbSerialParams)) {
            std::cerr << "Error: Unable to get UART state!" << std::endl;
            CloseHandle(hSerial);
            exit(EXIT_FAILURE);
        }

        dcbSerialParams.BaudRate = baudRate;
        dcbSerialParams.ByteSize = 8;
        dcbSerialParams.StopBits = ONESTOPBIT;
        dcbSerialParams.Parity   = NOPARITY;

        if (!SetCommState(hSerial, &dcbSerialParams)) {
            std::cerr << "Error: Unable to set UART parameters!" << std::endl;
            CloseHandle(hSerial);
            exit(EXIT_FAILURE);
        }
    }

    ~UART() {
        CloseHandle(hSerial);
    }

    void sendByte(uint8_t data) {
        DWORD bytesWritten;
        if (!WriteFile(hSerial, &data, 1, &bytesWritten, NULL)) {
            std::cerr << "Error: Failed to send data!" << std::endl;
        } else {
            std::cout << "Sent: " << static_cast<int>(data) << " (0x" << std::hex << static_cast<int>(data) << ") " << std::endl;
        }
    }
};

int main() {
    const char* portName = "COM8";  // Replace with your actual COM port
    int baudRate = CBR_9600;
    UART uart(portName, baudRate);

    std::ifstream assembly_f("assembler_test_out.txt"); 

    if (!assembly_f.is_open()) { // Check if file opened successfully
        std::cerr << "Error: Could not open the file." << std::endl;
        return 1;
    }

    // Hexadecimal string
    //std::string s = "0123456789ABCDEF";

    // Send each character as a byte
    std::string s;
    int i = 0;
    uint8_t start_byte = 0xaa;  // Convert hex character to byte
    uart.sendByte(start_byte);
    std::this_thread::sleep_for(std::chrono::milliseconds(100)); 
    while(std::getline(assembly_f, s)) 
    {

        std::cout << s << std::endl;
        // start byte
        
        for(int j = 0; j < 8; ++j)
        {
            std::cout << std::dec <<  static_cast<int>((j+1) * 2) << std::endl;
            uint8_t data = std::stoi(std::string(1, s[j]), nullptr, 16);  // Convert hex character to byte
            uart.sendByte(data);
            std::this_thread::sleep_for(std::chrono::milliseconds(100));  // Delay for 1 second
        }
        i++;
    }
    uint8_t end_byte = 0xBB;  // Convert hex character to byte
    uart.sendByte(end_byte);
    std::this_thread::sleep_for(std::chrono::milliseconds(100));    // Delay for 1 second
    //to turn off umupload
    end_byte = 0xCC;  // Convert hex character to byte
    uart.sendByte(end_byte);

    return 0;
}
