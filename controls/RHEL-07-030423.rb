# encoding: utf-8
# copyright: 2016, you
# license: All rights reserved
# date: 2016-01-14
# description: This Security Technical Implementation Guide is published as a tool to improve the security of Department of Defense (DoD) information systems. The requirements are derived from the National Institute of Standards and Technology (NIST) 800-53 and related documents. Comments or proposed revisions to this document should be sent via email to the following address: disa.stig_spt@mail.mil.
# impacts
title 'RHEL-07-030423 - All uses of the open_by_handle_at command must be audited.'
control 'RHEL-07-030423' do
  impact 0.5
  title 'All uses of the open_by_handle_at command must be audited.'
  desc 'Without generating audit records that are specific to the security and mission needs of the organization, it would be difficult to establish, correlate, and investigate the events relating to an incident or identify those responsible for one.  Audit records can be generated from various components within the information system (e.g., module or policy filter).  Satisfies: SRG-OS-000064-GPOS-00033, SRG-OS-000458-GPOS-00203, SRG-OS-000461-GPOS-00205, SRG-OS-000392-GPOS-00172'
  tag 'stig', 'RHEL-07-030423'
  tag severity: 'medium'
  tag checkid: 'C-RHEL-07-030423_chk'
  tag fixid: 'F-RHEL-07-030423_fix'
  tag version: 'RHEL-07-030423'
  tag ruleid: 'RHEL-07-030423_rule'
  tag fixtext: 'Configure the operating system to generate audit records when successful/unsuccessful attempts to use the “open_by_handle_at” command occur.

Add or update the following rule in /etc/audit/rules.d/audit.rules (removing those that do not match the CPU architecture):

-a always,exit -F arch=b32 -S open_by_handle_at -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -F subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 -F key=access

-a always,exit -F arch=b64 -S open_by_handle_at -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -F subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 -F key=access

The audit daemon must be restarted for the changes to take effect.'
  tag checktext: 'Verify the operating system generates audit records when successful/unsuccessful attempts to use the “open_by_handle_at” command occur.

Check the file system rules in /etc/audit/rules.d/audit.rules with the following commands:

Note: The output lines of the command are duplicated to cover both 32-bit and 64-bit architectures. Only the lines appropriate for the system architecture must be present.

# grep -i open_by_handle_at /etc/audit/rules.d/audit.rules

-a always,exit -F arch=b32 -S open_by_handle_at -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -F subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 -F key=access

-a always,exit -F arch=b64 -S open_by_handle_at -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -F subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 -F key=access

If the command does not return any output, this is a finding.'

# START_DESCRIBE RHEL-07-030423
  describe auditd_rules.syscall('open_by_handle_at').exit('-EPERM').arch('b32').key('access').action('always').list do
    it { should eq(['exit']) }
  end

  if os[:arch] == 'x86_64'
    describe auditd_rules.syscall('open_by_handle_at').exit('-EACCES').arch('b64').key('access').action('always').list do
      it { should eq(['exit']) }
    end
  end
# STOP_DESCRIBE RHEL-07-030423

end

