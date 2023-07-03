#include <set>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <iostream>
#include <stdbool.h>
#include <inttypes.h>
#include <sys/stat.h>
#include <time.h>
#include "vendor/ws/websocketpp/config/asio_no_tls.hpp"
#include "vendor/ws/websocketpp/server.hpp"

typedef websocketpp::server<websocketpp::config::asio> server;

using websocketpp::connection_hdl;
using websocketpp::lib::placeholders::_1;
using websocketpp::lib::placeholders::_2;
using websocketpp::lib::bind;

typedef std::set<connection_hdl,std::owner_less<connection_hdl>> con_list;

typedef server::message_ptr message_ptr;

void on_message(server* s, websocketpp::connection_hdl hdl, message_ptr msg) {
    std::cout << "on_message called with hdl: " << hdl.lock().get()
              << " and message: " << msg->get_payload()
              << std::endl;

    // check for a special command to instruct the server to stop listening so
    // it can be cleanly exited.
    if (msg->get_payload() == "stop-listening") {
        s->stop_listening();
        return;
    }

    try {
        s->send(hdl, msg->get_payload(), msg->get_opcode());
    } catch (websocketpp::exception const & e) {
        std::cout << "Echo failed because: "
                  << "(" << e.what() << ")" << std::endl;
    }
}

void on_open(server* s, websocketpp::connection_hdl hdl) {
    std::cout << "new connection" << std::endl;
}


void on_close(server* s, websocketpp::connection_hdl hdl) {
    std::cout << "closed connection" << std::endl;
}



int main(int argc, char* argv[]) {
    // Create a server endpoint
    server wagent;

    try {
        // Set logging settings
        wagent.set_access_channels(websocketpp::log::alevel::all);
        wagent.clear_access_channels(websocketpp::log::alevel::frame_payload);

        // Initialize Asio
        wagent.init_asio();

        // Register our message handler
        wagent.set_message_handler(bind(&on_message, &wagent, ::_1, ::_2));
        wagent.set_open_handler(bind(&on_open, &wagent, ::_1));
        wagent.set_close_handler(bind(&on_close, &wagent, ::_1));

        // Listen on port 9002
        wagent.listen(9002);

        // Start the server accept loop
        wagent.start_accept();

        // Start the ASIO io_service run loop
        wagent.run();
    } catch (websocketpp::exception const & e) {
        std::cout << e.what() << std::endl;
    } catch (...) {
        std::cout << "other exception" << std::endl;
    }
}
