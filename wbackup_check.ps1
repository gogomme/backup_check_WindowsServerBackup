clear

# Récupère l'heure et la date et le hostname du serveur

$date = Get-Date -Format "yyyy-MM-dd"
$heure = Get-Date -Format "HH:mm:ss"
$hostname = hostname

# Récupère l'état du dernier job Windows Server Backup termimer (pour avoir celui en cours enlever -Previous 1)

$Jobs = Get-WBJob -Previous 1

# Récupère les objets suivants :
# HResult qui le code d'état de la tache.
# ErrorDescription dans le cas d'une erreur.
# Startime et Endtime qui est le début et la fin de la tache
# Job state pour vérifier si il y a un faux positif, dans le cas d'un Unknow

$HResults = $Jobs | Select-Object -ExpandProperty HResult
$ErrorDescription = $Jobs | Select-Object -ExpandProperty ErrorDescription
$StartTime = $Jobs | Select-Object -ExpandProperty StartTime
$EndTime = $Jobs | Select-Object -ExpandProperty EndTime
$JobState = $Jobs | Select-Object -ExpandProperty JobState


# Affiche des infos sur la vérification en cours dans le terminal

Write-Output "Etat de la dernière sauvegarde Windows Server Backup du $date à $heure sur le serveur $hostname"
Write-Output "Le Hresult de la sauvegarde est $HResults"


# Vérifier si $HResult est une chaîne de caractères
if ($HResults -is [string]) {

    # Vérification de la valeur de $HResult est 0 et que la status du job en Completed
    if ($HResults -eq "0"-and $JobState -eq "Completed") 
    {
        # si c'est le cas :
        Write-Output "La sauvegarde s'est bien déroulé."
        Write-Output "Job start at : $StartTime "
        Write-Output "Job end at : $EndTime "
        Write-Output "Job status : $JobState "
    } 
    
    # Vérification de la valeur de $HResult est null et/ou que la status du job n'est pas completed
    elseif ($HResults -eq $null -or $HResults -eq '' -or $JobState -ne "Completed")
    {
        # Si $HResult est null la sauvegarde n'est pas vérifiable, retourner 1 pour remonter l'erreur
        Write-Output "Le résultat est null, impossible de vérifier la sauvegarde."
        Write-Output "La description de l'erreur est : $ErrorDescription"
        Write-Output "Job start at : $StartTime "
        Write-Output "Job end at : $EndTime "
        Write-Output "Job status : $JobState "
        exit 1

    } 
    else 
    {
        # Si $HResult est différent de 0 et n'est pas null alors le Hresult est un code d'erreur ou d'avertissement, retourner 1 pour remonter l'erreur
        Write-Output "La sauvegarde est en erreur, veuilliez vérifier le problème sur le serveur $hostname."
        Write-Output "La description de l'erreur est : $ErrorDescription"
        Write-Output "Job start at : $StartTime "
        Write-Output "Job end at : $EndTime "
        Write-Output "Job status : $JobState "
        exit 1
    }
} else 
{
    Write-Output "HResults n'est pas une chaîne de caractères, impossible de vérifier la sauvegarde."
    exit 1
}
