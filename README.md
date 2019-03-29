# scp-test
To test the reliability of scp uploads to a server.

I had some trouble with the reliability of uploads via scp to a server and used this scripts to test and log the situation.

The script assumes that you have ssh access to the server in question and that you have write access to the `/tmp` of the server. The script uploads 100 copies of a random file of 20MB.

Syntax:
```
$ scp-test <server_name>
```
