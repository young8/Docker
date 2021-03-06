#!/bin/bash
#file of Fernando Mayo <fernando@tutum.co>, Feng Honglin <hfeng@tutum.co>

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

PASS=$(cat /app/files/khdfgeaqejalh/bdd)
echo "=> Creating MySQL admin user with $PASS password"

mysql -uroot -e "CREATE USER 'admin'@'%' IDENTIFIED BY '$PASS'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"

# You can create a /mysql-setup.sh file to intialized the DB
if [ -f /scripts/setup-mysql.sh ] ; then
   echo "=> Initialization of the DB"
   ./scripts/setup-mysql.sh
fi

echo "=> Done!"

mysqladmin -uroot shutdown
