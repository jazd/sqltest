#!/bin/bash

set -e

if [ $# -eq 1 ]
then
    # Build test execution container
    docker build -t sqltest:2.7 -f Containerfile .

    # TODO: test for already running sqltest and servers

    # Run test execution container
    docker run -d -t --name sqltest --network sqltest-net -v "`pwd`:/tmp/sql" --rm sqltest:2.7

    # Launch database server container and run test against it using the sqltest container
    if [ $1 = all ] || [ $1 = pg9.2 ]
    then
	echo pg9.2 start
	docker run -d --name pg9.2 --network sqltest-net --publish 5432 --rm postgres:9.2
	docker exec sqltest /bin/sh -c "cd /tmp/sql && ./wait-for-it.sh -t 60 pg9.2:5432 && python generate_tests.py server.postgresql.v9_2"
	docker stop pg9.2 &>/dev/null 2>&1 & disown;
	echo pg9.2 finish
    fi

    if [ $1 = all ] || [ $1 = pg9.6 ]
    then
	echo pg9.6 start
	docker run -d --name pg9.6 --network sqltest-net --publish 5432 --rm -e POSTGRES_HOST_AUTH_METHOD=trust postgres:9.6
	docker exec sqltest /bin/sh -c "cd /tmp/sql && ./wait-for-it.sh -t 60 pg9.6:5432 && python generate_tests.py server.postgresql.v9_6"
	docker stop pg9.6 &>/dev/null 2>&1 & disown;
	echo pg9.6 finish
    fi

    if [ $1 = all ] || [ $1 = my5.5 ]
    then
	echo my5.5 start
	docker run -d --name my5.5 --network sqltest-net --publish 3306 --rm -e MYSQL_ALLOW_EMPTY_PASSWORD=1 -e MYSQL_DATABASE=test mysql:5.5
	docker exec sqltest /bin/sh -c "cd /tmp/sql && ./wait-for-it.sh -t 60 my5.5:3306 && python generate_tests.py server.mysql.v5_5"
	docker stop my5.5 &>/dev/null 2>&1 & disown;
	echo my5.5 finish
    fi

    if [ $1 = all ] || [ $1 = my5.6 ]
    then
	echo my5.6 start
	docker run -d --name my5.6 --network sqltest-net --publish 3306 --rm -e MYSQL_ALLOW_EMPTY_PASSWORD=1 -e MYSQL_DATABASE=test mysql:5.6
	docker exec sqltest /bin/sh -c "cd /tmp/sql && ./wait-for-it.sh -t 60 my5.6:3306 && python generate_tests.py server.mysql.v5_6"
	docker stop my5.6 &>/dev/null 2>&1 & disown;
	echo my5.6 finish
    fi

    if [ $1 = all ] || [ $1 = my5.7 ]
    then
	echo my5.7 start
	docker run -d --name my5.7 --network sqltest-net --publish 3306 --rm -e MYSQL_ALLOW_EMPTY_PASSWORD=1 -e MYSQL_DATABASE=test mysql:5.7
	docker exec sqltest /bin/sh -c "cd /tmp/sql && ./wait-for-it.sh -t 60 my5.7:3306 && python generate_tests.py server.mysql.v5_7"
	docker stop my5.7 &>/dev/null 2>&1 & disown;
	echo my5.7 finish
    fi

    if [ $1 = all ] || [ $1 = my8.0 ]
    then
	echo my8.0 start
	docker run -d --name my8.0 --network sqltest-net --publish 3306 --rm -e MYSQL_ALLOW_EMPTY_PASSWORD=1 -e MYSQL_DATABASE=test mysql:8.0
	docker exec sqltest /bin/sh -c "cd /tmp/sql && ./wait-for-it.sh -t 60 my8.0:3306 && python generate_tests.py server.mysql.v8_0"
	docker stop my8.0 &>/dev/null 2>&1 & disown;
	echo my8.0 finish
    fi

    echo stopping test execution container
    docker stop sqltest
else
    echo "usage ./test.sh [all|\
pg9.2|\
pg9.6|\
my5.5|\
my5.6|\
my5.7|\
my8.0]"
fi
