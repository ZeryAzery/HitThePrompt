# C# Stuff in Windows


You can build native apps for Android, iOS, and Windows by using C#. C# is multi OS, easily compiles to other OS's, not just Windows.

### Créer le fichier Adminlocaux.cs
```powershell 
ni AdminsLocaux.cs
```


### Vérifier si dotnet installé et si le system trouve le compileur csc
```powershell
dotnet --version
where csc
```

### Installer .NET (SDK)
```powershell
wget https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.102/dotnet-sdk-10.0.102-win-x64.exe
& C:\Users\aziegler\Downloads\dotnet-sdk-10.0.102-win-x64.exe /install /norestart # /quiet
dotnet --version
```


### Trouver/vérifier si le compileur csc.exe est présent/installé
```powershell 
Get-ChildItem C:\Windows\Microsoft.NET\Framework* -Recurse -Filter csc.exe
```

Si Répertoire présent: C:\Windows\Microsoft.NET\Framework64\v4.0.30319 l'ajouter au PATH ou le lancer depuis le dossier 


### Tester si le compileur fonctionne sans PATH
```powershell
& "$env:WINDIR\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
```


### Vérifier ce qui se trouve dans le Path (system + user)
```powershell
$env:Path -split ';'
```


### Afficher seulement le PATH machine
```powershell
[Environment]::GetEnvironmentVariable("Path", "Machine") -split ';'
```


### Afficher seulement le PATH utilisateur
```powershell
[Environment]::GetEnvironmentVariable("Path", "User") -split ';'
```


### Des fois pour que le Path prenne effet il faut se déco
```powershell 
logoff
```

### Il est possible de compiler dans le terminal powershell directement: (exemple)
```powershell
Add-Type -TypeDefinition @"
using System;
using System.Collections;
using System.DirectoryServices;
using System.Security.Principal;

public class AdminsLocaux
{
    public static void Run()
    {
        DirectoryEntry computer =
            new DirectoryEntry($"WinNT://{Environment.MachineName}");

        foreach (DirectoryEntry child in computer.Children)
        {
            if (child.SchemaClassName != "group")
                continue;

            if (child.Properties["objectSID"].Value == null)
                continue;

            var sid = new SecurityIdentifier(
                (byte[])child.Properties["objectSID"].Value, 0
            );

            if (sid.Value != "S-1-5-32-544")
                continue;

            foreach (object member in (IEnumerable)child.Invoke("Members"))
            {
                DirectoryEntry user = new DirectoryEntry(member);
                Console.WriteLine(user.Path);
            }
        }
    }
}
"@

[AdminsLocaux]::Run()
```

### Compiler AdminsLocaux.cs en .exe
```powershell
csc.exe AdminsLocaux.cs
```