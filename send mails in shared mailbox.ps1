# Set-ExecutionPolicy RemoteSigned <-- need


# Mailboxes in Microsoft 365 or Office 365 can be set up so that someone (such as an executive assistant) 
# can access the mailbox of another person (such as a manager) and send mail as them. 
# These people are often called the delegate and the delegator, respectively. 
# We'll call them "assistant" and "manager" for simplicity's sake. 
# When an assistant is granted access to a manager's mailbox, it's called delegated access.

# People often set up delegated access and send permissions to allow an assistant to manage a manager's calendar 
# where they need to send and respond to meeting requests. By default, when an assistant sends mail as, 
# or on behalf of, a manager, the sent message is stored in the assistant's Sent Items folder. 
# You can use this article to change this behavior so that the sent message is stored in both the assistant 
# and manager's Sent Items folders. <-- https://learn.microsoft.com/en-us/exchange/recipients-in-exchange-online/manage-user-mailboxes/automatically-save-sent-items-in-delegator-s-mailbox

#shared mailbox
$mailbox = ""
#Credential having permission on shared mailbox
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session
get-mailbox $mailbox
set-mailbox $mailbox -MessageCopyForSentAsEnabled $True
set-mailbox $mailbox -MessageCopyForSendOnBehalfEnabled $True