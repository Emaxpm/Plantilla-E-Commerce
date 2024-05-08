# Obtiene la ruta absoluta del directorio del script .ps1
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path

# Obtiene la ruta absoluta del directorio del proyecto (la raíz)
$projectDirectory = Resolve-Path "$scriptDirectory\..\.."

# Define la ruta completa al archivo .env
$envFilePath = Join-Path -Path $projectDirectory -ChildPath '.env'

# Lee el contenido del archivo .env
$envFileContent = Get-Content -Path $envFilePath

# Define un diccionario para almacenar las variables
$envVariables = @{}

# Parsea las variables del archivo .env y las agrega al diccionario
foreach ($line in $envFileContent) {
    $key, $value = $line -split '=', 2
    if ($key -ne $null -and $value -ne $null) {
        $envVariables[$key.Trim()] = $value.Trim()
    }
}

# Accede a las variables necesarias (tratando todos los valores como cadenas)
$dbName = $envVariables["DB_NAME"]
$dbUser = $envVariables["DB_USER"]
$dbUrl = $envVariables["DB_URL"]

# Usa las variables en tu script
Remove-Item -Recurse -Force "$projectDirectory\migrations" -ErrorAction SilentlyContinue
pipenv run init
mysql -h $dbUrl -u $dbUser -p -e "DROP DATABASE IF EXISTS $dbName"
mysql -h $dbUrl -u $dbUser -p -e "CREATE DATABASE $dbName"
pipenv run migrate
pipenv run upgrade