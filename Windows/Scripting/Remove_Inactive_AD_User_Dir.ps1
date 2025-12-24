#------------------------------------------------------------------------------------------------#
#                                                                                                #
#   This script allows you to detect and remove directories from old unused user accounts        #
#   You can review the accounts stored in the specified OU before choosing the removal option    #
#   This script only works if you use an OU for disabled accounts                                #
#   Note that the user directory will be permanently removed from the PC                         #
#   Accounts are detected as soon as they are placed in the chosen OU (here: OU=INACTIFS)        #
#   Rename with your domain credentials and OU name (line 25)                                    #
#                                                                                                #
#------------------------------------------------------------------------------------------------#

$currentUser = $env:USERNAME
$exclude = @("Public", "Default", "Default User", "All Users", $currentUser)

# Récupère les dossiers dans C:\Users 
$userDirs = Get-ChildItem "C:\Users" -Directory |
    Where-Object { $exclude -notcontains $_.Name } |
    ForEach-Object { $_.Name }

# Variable pour stocker tous les logins trouvés dans INACTIFS
$inactiveUsers = @()

foreach ($login in $userDirs) {
    $Searcher = New-Object DirectoryServices.DirectorySearcher
    $Searcher.SearchRoot = "LDAP://OU=INACTIFS,DC=<domain-name>,DC=<domain-TLD>"
    $Searcher.Filter = "(&(objectClass=user)(sAMAccountName=$login))"

    $result = $Searcher.FindOne()

    if ($result) {
        Write-Host "$login trouvé dans l'OU INACTIFS : $($result.Properties.distinguishedname)" -ForegroundColor Green
        $inactiveUsers += $login
    }
    else {
        Write-Host "$login non trouvé dans l'OU INACTIFS" -ForegroundColor Yellow
    }
}

# Choix principal
$validChoices = @("S","A","C")
$AdmResponse = ""

while ($AdmResponse -notin $validChoices) {
    $AdmResponse = Read-Host "Que voulez-vous faire ? (S=Supprimer tout, A=Annuler, C=Choisir)"
}

switch ($AdmResponse) {
    "S" {
        foreach ($user in $inactiveUsers) {
            cmd.exe /c "rmdir /s /q `"C:\Users\$user`""
            Write-Host "Dossier supprimé : C:\Users\$user" -ForegroundColor Green
        }
    }
    
    "A" {
        Write-Host "Action annulée." -ForegroundColor Yellow
    }

    "C" {
        Write-Host "Utilisateurs disponibles :" -ForegroundColor Cyan
        $inactiveUsers | ForEach-Object { Write-Host $_ -ForegroundColor Green }

        while ($true) {
            $usertoremove = Read-Host "Entrez le login à supprimer (ou tapez S pour arrêter)"
            if ($usertoremove -eq "S") { break }

            if ($inactiveUsers -contains $usertoremove) {
                cmd.exe /c "rmdir /s /q `"C:\Users\$usertoremove`""
                Write-Host "Dossier supprimé : C:\Users\$usertoremove" -ForegroundColor Green
            }
            else {
                Write-Host "Utilisateur '$usertoremove' non trouvé dans la liste." -ForegroundColor Red
            }
        }
    }
}

pause
