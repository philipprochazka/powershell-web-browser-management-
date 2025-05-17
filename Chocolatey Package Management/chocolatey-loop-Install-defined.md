$Packages = 'googlechrome', 'git', 'notepadplusplus', 'sql-server-management-studio'

ForEach ($PackageName in $Packages)
{
    choco install $PackageName -y
}