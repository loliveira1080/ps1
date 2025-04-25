$user = Read-Host "Entre com o nome de usuário"
$dc = Read-Host "Entre com o nome servidor de domínio"
$domainControllers = Get-ADDomainController -Filter * -Server $dc
$lastLogon = $null

foreach ($domainController in $domainControllers) {
	    $userObject = Get-ADUser -Filter {samaccountname -eq $user} -Properties lastLogon -Server $domainController.HostName
	        if ($userObject.lastLogon) {
			        $logonTime = [DateTime]::FromFileTime($userObject.lastLogon)
				        if ($lastLogon -eq $null -or $logonTime -gt $lastLogon) {
						            $lastLogon = $logonTime
							            }
								        }
}

if ($lastLogon) {
	    Write-Output "O último login do usuário $user foi em: $lastLogon"
} else {
	    Write-Output "Nenhum registro de login encontrado para o usuário $user."
}
