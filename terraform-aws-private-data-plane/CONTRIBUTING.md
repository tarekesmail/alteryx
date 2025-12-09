# Contributing to this code base

## AWS Policy Files

In the `./modules/pdh-iam/` directory is terraform code that `can` be used to
create AWS policy resources and assign them to an AWS service account.  This
module is *NOT* used in the provisioning of a customer account `PDP`.  It *IS*
used by our internal `DDP` provisioning, which uses the `./dp-project` terraform
to provision an `account` and also apply the `whitepaper` items.

When adding terraform code be sure to include any permissions that are required
so that everything stays versioned together.  When provisioning a `PDP` for a
customer, we are using the git-tag to define the `version` of the terraform
code that we will be applying.  The infra-dataplane-service code will use this
same version to read the policy JSON files from `./modules/pdh-iam/policies/*`
and use them to validate that the customer has applied the correct JSON policy.


## 📝 Commit Requirements

This repository uses automated releases. **At least one commit per MR** must follow [Conventional Commits](https://www.conventionalcommits.org/) and **include your ticket number**:

```
feat: [TCIA-1234] add new feature
fix: [TCIA-5678] resolve bug issue
docs: [TCIA-9012] update documentation
chore: [TCIA-3456] update dependencies
```

**Ticket references create clickable links in automated changelogs.**

## ⚠️ Important

- Pipeline **will fail** if no conventional commits found
- MR cannot be merged until commit format is fixed
- Automated releases depend on proper commit types

**Need help?** Contact the Cloud Infrastructure & Automation team.