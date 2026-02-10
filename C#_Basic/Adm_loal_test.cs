using System;
using System.Collections;
using System.Collections.Generic;
using System.DirectoryServices;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Net.NetworkInformation;


class Program
{
    static StreamWriter writer;
    static int machinesInjoignables = 0;

    static void Main()
    {
        writer = new StreamWriter("AdminsLocaux_DNS.txt", false);

        HashSet<string> machines = GetMachinesFromDNS();

        foreach (string machine in machines)
        {
            ProcessMachine(machine);
        }

        writer.WriteLine();
        writer.WriteLine(
            "Nombre de machines qui n'ont pas donné de réponses : " +
            machinesInjoignables
        );

        writer.Close();

        Console.WriteLine("Terminé. Résultat dans AdminsLocaux_DNS.txt");
        Console.ReadLine();
    }

    static HashSet<string> GetMachinesFromDNS()
    {
        HashSet<string> names = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        string domain = IPGlobalProperties.GetIPGlobalProperties().DomainName;

        try
        {
            IPHostEntry entry = Dns.GetHostEntry(domain);

            foreach (IPAddress ip in entry.AddressList)
            {
                try
                {
                    IPHostEntry host = Dns.GetHostEntry(ip);
                    string hostname = host.HostName.Split('.')[0];
                    names.Add(hostname);
                }
                catch { }
            }
        }
        catch { }

        return names;
    }

    static void ProcessMachine(string computerName)
    {
        try
        {
            DirectoryEntry group =
                new DirectoryEntry("WinNT://" + computerName + "/Administrateurs,group");

            foreach (object member in (IEnumerable)group.Invoke("Members"))
            {
                DirectoryEntry user = new DirectoryEntry(member);
                string line = computerName + " : " + user.Name;

                Console.WriteLine(line);
                writer.WriteLine(line);
            }
        }
        catch
        {
            machinesInjoignables++;
            string line = computerName + " : MACHINE INJOIGNABLE";

            Console.WriteLine(line);
            writer.WriteLine(line);
        }
    }
}
