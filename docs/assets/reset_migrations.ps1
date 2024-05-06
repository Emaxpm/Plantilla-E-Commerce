Remove-Item -Recurse -Force .\migrations -ErrorAction SilentlyContinue
pipenv run init
mysql -h localhost -u root -pyuna0898 -e "DROP DATABASE IF EXISTS ecommerce"
mysql -h localhost -u root -pyuna0898 -e "CREATE DATABASE ecommerce"
mysql -h localhost -u root -pyuna0898 ecommerce -e "CREATE EXTENSION unaccent;"
pipenv run migrate
pipenv run upgrade