# SML Server

The backend for the CS52 Grader (in progress)

## How it works

File paths are uploaded to the localhost server via a `GET` request, which are then run inside of the web sever.  
In actual use, the autograder will upload the students' code along with any tests.

In order to get results, another `GET` request is sent, which returns all relevant test results

### Why a Web Server?

The web server is used to persist one instance of SML across a student's problems.  If a problem is incorrect or contains errors, the web server will handle the errors but not crash.  As such, the correct solution can be uploaded and grading can continue without fear of double penalizing students.  

## Usage

### With `SML/NJ`

Startup server with `sml start_sever.sml`

### Crappy `GET` request format:

System Check:
`GET /status`
File Upload:
`GET /file/path/to/file`
Result Check:
`GET /results/p/s_p`
> where `p` is the problem number, `s_p` is the sub_problem number; `""` if None

Kill Server
`GET /kill`

### Test Format

The most important thing that needs to happen is the following line:

`addEntry(p, s_p, n, result_code)`

> where `p` is the problem number, `s_p` is the sub_problem number; `""` if None, and `n` is the test number
> `result_code`
> `"0"` : complete, correct
> `"1"` : complete, incorrect
> `"2"` : incomplete, errored

#### Example Problem and Test:

```
fun foo x y = x * y;
```

```
val ret = assertEquals (foo 8 5) (40);
addEntry(("1", "", "1", ret));

val ret = assertEquals (foo 8 6) (48);
addEntry(("1", "", "2", ret));

val ret = assertEquals (foo 8 7) (56);
addEntry(("1", "", "3", ret));
```

#### Result code format:

Results are returned in the following format

> [p/s_p/n/r_c | ]

i.e,
> 1/ /1/0|1/ /2/0|1/ /3/0|


