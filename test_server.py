import http.client
import subprocess

def test_connection() -> bool:
	conn = http.client.HTTPConnection("localhost:8181")
	conn.request("GET", "status")
	#conn.request("GET", "filename/%s" %(filename))

	r1 = conn.getresponse()
	print(r1.status.type(), r1.reason)
	print(r1.read())
	return True

def use_file(filename:str) -> bool:
	conn = http.client.HTTPConnection("localhost:8181")
	conn.request("GET", "file/%s" %(filename))
	#conn.request("GET", "filename/%s" %(filename))

	r1 = conn.getresponse()
	print(r1.status, r1.reason)
	print(r1.read())
	return True

def get_results(problem_number:int) -> tuple:
	conn = http.client.HTTPConnection("localhost:8181")
	conn.request("GET", "results/%i" %(problem_number))
	#conn.request("GET", "filename/%s" %(filename))
	r1 = conn.getresponse
	print(type(r1))
	print(r1.status, r1.reason)
	print(r1.read())
	return ()

def kill_server():
	conn = http.client.HTTPConnection("localhost:8181")
	conn.request("GET", "kill")
	try:
		conn.getresponse()
	except ConnectionResetError:
		pass


p = subprocess.Popen("sml start_server.sml", shell=True)
try:
	test_connection()
	use_file("example_sml/sample_assignment.sml")
	use_file("example_sml/simple_test.sml")
	use_file("example_sml/simple_test_2.sml")
	get_results(1)
	kill_server()
except:
	kill_server()


