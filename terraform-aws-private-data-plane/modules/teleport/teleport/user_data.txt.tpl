<powershell>
${local_user_data}
cd \Users\Administrator\Downloads
echo ${tprt_cert} > teleport.cer.b64
certutil -decode teleport.cer.b64 teleport.cer
cd \Software
.\teleport-windows-auth-setup.exe install --cert=\Users\Administrator\Downloads\teleport.cer -r
</powershell>
