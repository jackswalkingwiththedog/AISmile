from http.server import SimpleHTTPRequestHandler
import socketserver

PORT = 80

class MyRequestHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        if '.' not in self.path:
            self.path = '/'
        return SimpleHTTPRequestHandler.do_GET(self)

server = socketserver.TCPServer(('', PORT), MyRequestHandler)
print("Serving at PORT : " + str(PORT))
server.serve_forever()