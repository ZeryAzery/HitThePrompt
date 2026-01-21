# 🖼️ Sysprep 🖼️ 

Faire le sysprep avant le clone si besoin de déployer l'image plusieurs fois et choisir arrêter au lieu de redémarrer (pour éviter que la machine reprenne un SID au démarrage)

* Et vérifier dans Paramètres > Windows Update qu’il n’y a rien en attente.
* Ne pas syprep un PC sur domaine
* Pas d’application UWP installée par utilisateur (genre Candy Crush, Spotify, etc.)


Une fois sur le compte admin built-in de windows installer tous ce que vous souhaitez (logiciels, pilotes...)
lancer sysprep



<br>

---

<br>


## sysprep
```powershell
# Emplacement sysprep
cd \windows\system32\sysprep
# Exécuter sysprep
.\sysprep.exe /generalize /reboot
```


<br>

---

<br>


## run sysprep avec un fichier unattend.xml
```batch
cd %WINDIR%\System32\Sysprep
sysprep /generalize /oobe /shutdown /unattend:C:\Windows\System32\Sysprep\Unattend.xml
```

* Chemin des logs sysprep:
```
%WINDIR%\System32\Sysprep\Panther\setupact.log
```


<br>

---

<br>


## Erreurs de sysprep

Si sysprep refuse de fonctionner faite un sysprep en audit sans généralisation via interface graphique :
Dans exécuter taper sysprep puis audit ne cocher pas généraliser et faite reboot.

Vous allez ensuite vous retrouver sur le compte administrateur et non le compte built-in. Utiliser "exécuter" puis taper "control" et rdv dans la section utilisateur, et supprimer le compte buit-in du départ.

À ce moment réessayer de nouveau sysprep en ligne de commande via powershell:
```powershell
cd \windows\system32\sysprep
sysprep.exe /generalize /reboot
```
- *Error 0x800F0975* (Reserved storage is in use)
```powershell
DISM.exe /Online /Set-ReservedStorageState /State:Disabled
```
- *Error SYSPRP Package Microsoft.WidgetsPlatformRuntime_1.6.9.0_x64__8wekyb3d8bbwe was installed for a user, but not provisioned for all users.*
```powershell
# Supprimer l’application problématique
Get-AppxPackage -Name Microsoft.WidgetsPlatformRuntime | Remove-AppxPackage
#  Supprimer aussi le package provisionné (si présent) :
Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "*WidgetsPlatformRuntime*" | Remove-AppxProvisionedPackage -Online
```
-  *UnattendErrorFromResults: Error text = Windows n’a pas pu analyser ou traiter le fichier de réponses sans assistance pour l’étape [generalize]. Un composant ou un paramètre spécifié dans le fichier de réponses n’existe pas.*

 -> Sysprep indique que le fichier Unattend est absent ou qu'il cherche à en charger un, vérifier qu'aucun fichier unattend ne sois dans le dossier sysprep sinon essayer de lancer sysprep en powershell...



<br>

---

<br>



# DISM

## Capturer une image disque avec DISM
 Booter sur une image ISO Windows presser shit + F10 pour avoir la CMD
 Si vous utiliser une machine physique utiliser une clé USB ( >= à 64 Go) ou un disque dur

 ### Utiliser diskpart pour visualiser le nom des disques et des volumes
 ```batch
 diskpart
 lis dis
 lis vol
 sel vol 3
 ass letter C
 sel vol 5 
 ass letter D
 exit
 ```
 ### Capturer l'image 
 * Ici "D:\image\install.wim" est le nom et l'emplacement de la sauvegarde et "C:\" est le dossier qu'on capture.
 ```batch
 dism /capture-image /imagefile:D:\image\install.wim /capturedir:C:\ /name:win11_abej
 ```

