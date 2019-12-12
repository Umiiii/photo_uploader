from http.server import HTTPServer, BaseHTTPRequestHandler

import cgi


class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):

    def do_POST(self):
        self.send_response(200)
        self.end_headers()
        content_len = int(self.headers.getheader('content-length', 0))
        print("Image length",content_len)
        post_body = self.rfile.read(content_len)
        file = open('hacked.png','w')
        file.write(post_body)
        file.close()
        

httpd = HTTPServer(('localhost', 8000), SimpleHTTPRequestHandler)
httpd.serve_forever()