wget http://mirrors.sohu.com/nginx/nginx-1.19.2.tar.gz

yum -y install gcc gcc-c++ automake pcre pcre-devel zlib zlib-devel openssl openssl-devel  # 安装所有的依赖配件

tar -xvf nginx-1.19.2.tar.gz

cd nginx-1.19.2

./configure

make

make install 

cd /usr/local/nginx/sbin/

./nginx -v # 输出版本号即可