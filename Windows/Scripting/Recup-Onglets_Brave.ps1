# Ce script PowerShell récupère les onglets ouverts dans le navigateur Brave et les enregistre dans un fichier texte sur le bureau.

& "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe" --remote-debugging-port=9222

$Date = Get-Date -Format 'dd-MM-yy'
$Output = "$HOME\Desktop\Brave_Onglets_$Date.txt"

try {
    $Tabs = Invoke-RestMethod "http://127.0.0.1:9222/json"

    $Tabs |
        Where-Object { $_.type -eq "page" } |
        Select-Object title, url |
        Sort-Object title |
        ForEach-Object {
            "$($_.title)`r`n$($_.url)`r`n"
        } |
        Set-Content $Output -Encoding UTF8

    Write-Host "Terminé." -ForegroundColor Green
    Write-Host "Fichier créé : $Output"
    Write-Host ""
}
catch {
    Write-Host "Impossible de se connecter à Brave."
    Write-Host "Vérifier qu'il est lancé avec :"
    Write-Host "--remote-debugging-port=9222"
}

pause


# EXPLICATIONS :

# `r`n équivalent à un saut de ligne (retour chariot + nouvelle ligne) pour Windows. (Le \n de Linux ne fonctionne pas sur Windows)

# --remote-debugging-port=9222 permet de se connecter à Brave via le protocole DevTools. Il faut lancer Brave avec cette option pour que le script fonctionne.


# Invoke-RestMethod "http://127.0.0.1:9222/json" permet de récupérer les onglets ouverts dans Brave via l'API DevTools. 
# Le résultat est un tableau d'objets JSON contenant des informations sur chaque onglet, comme le titre et l'URL.


# Brave répond avec un document JSON ressemblant à ceci (simplifié) :

# [
#     {
#         "description": "",
#         "id": "2D6C...",
#         "title": "OpenAI",
#         "type": "page",
#         "url": "https://chatgpt.com/",
#         "webSocketDebuggerUrl": "ws://127.0.0.1:9222/..."
#     },
#     {
#         "title": "GitHub",
#         "type": "page",
#         "url": "https://github.com/"
#     }
# ]

# PowerShell convertit automatiquement ce JSON en objets PowerShell.
# On peut utiliser $Tabs | Get-Member pour voir les propriétés disponibles, comme title et url.