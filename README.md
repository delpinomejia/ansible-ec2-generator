# 🚀 Ansible EC2 Instance Generator

<div align="center">

![Ansible](https://img.shields.io/badge/ansible-%231A1918.svg?style=for-the-badge&logo=ansible&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ansible Galaxy](https://img.shields.io/badge/Ansible-Galaxy-blue.svg)](https://galaxy.ansible.com/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

**🎯 Effortlessly deploy AWS EC2 instances with enterprise-grade automation**

</div>

---

## 📖 Overview

The **Ansible EC2 Instance Generator** is a comprehensive automation solution that allows you to effortlessly spin up AWS EC2 instances for development, testing, or production purposes. Built with modern Ansible practices, it includes cost optimization, security best practices, and enterprise-grade features.

### ✨ Key Highlights

- 🔍 **Smart AMI Discovery** - Automatically finds the latest AMI matching your criteria
- 💰 **Cost Estimation** - Real-time cost calculations before deployment
- 🏷️ **Comprehensive Tagging** - Enterprise-grade resource management
- 🔑 **Dynamic SSH Keys** - Auto-generated key pairs for enhanced security
- 🔒 **Security First** - Built-in security best practices and encryption
- 🧪 **CI/CD Ready** - Complete GitHub Actions workflow with manual cleanup stage
- 🧹 **Smart Cleanup** - Automated resource discovery and termination
- 🛠️ **Zero Dependencies** - Uses AWS CLI instead of complex Ansible collections

---

## 🛠️ Prerequisites

| Requirement | Version | Purpose |
|-------------|---------|----------|
| ![Ansible](https://img.shields.io/badge/Ansible-2.9+-red?logo=ansible) | 2.9+ | Automation engine |
| ![AWS](https://img.shields.io/badge/AWS-Account-orange?logo=amazon-aws) | - | Cloud provider |
| ![SSH](https://img.shields.io/badge/SSH-Key%20Pair-blue?logo=openssh) | - | Instance access |
| ![VPC](https://img.shields.io/badge/VPC-Resources-green?logo=amazon-aws) | - | Network infrastructure |

---

## 🚀 Quick Start

### 1️⃣ Clone the Repository
```bash
git clone <your-repo-url>
cd ansible-ec2-generator
```

### 2️⃣ Install Dependencies
```bash
# Install required Ansible collections
ansible-galaxy collection install amazon.aws
ansible-galaxy collection install community.general

# Verify installation
ansible-galaxy collection list
```

### 3️⃣ Configure Variables
```bash
# Copy sample configuration
cp vars/vars_sample.yml vars/vars.yml

# Edit with your AWS settings
vim vars/vars.yml  # or your preferred editor
```

### 4️⃣ Deploy Instance
```bash
# Run the playbook
ansible-playbook ec2-playbook.yml

# Or with specific tags
ansible-playbook ec2-playbook.yml --tags "validation,create"
```

---

## 🎯 Features Matrix

| Feature | Status | Description |
|---------|--------|-------------|
| 🔍 **AMI Discovery** | ✅ | Automatic latest AMI selection |
| 💰 **Cost Estimation** | ✅ | Pre-deployment cost calculations |
| 🏷️ **Smart Tagging** | ✅ | Comprehensive resource tagging |
| 🔔 **Slack Notifications** | ✅ | Team collaboration alerts |
| 🔒 **Security Scanning** | ✅ | Built-in security validations |
| 🧪 **SSH Testing** | ✅ | Connectivity verification |
| 📊 **Multi-Environment** | ✅ | Dev/Test/Prod configurations |
| 🔄 **CI/CD Pipeline** | ✅ | Complete GitHub Actions integration |

---

## 📁 Project Structure

```
ansible-ec2-generator/
├── 📄 ec2-playbook.yml      # Main Ansible playbook
├── 📄 cleanup-playbook.yml  # Resource cleanup playbook
├── 📁 vars/
│   ├── 📄 vars_sample.yml    # Configuration template
│   └── 📄 vars.yml          # Your configuration (create this)
├── 📁 .github/
│   ├── 📁 workflows/
│   │   └── 📄 deploy.yml     # GitHub Actions workflow
│   ├── 📁 ISSUE_TEMPLATE/    # Issue templates
│   └── 📄 pull_request_template.md
├── 📄 README.md            # This file
└── 📄 .gitignore           # Git ignore rules
```

---

## ⚙️ Configuration Options

<details>
<summary>🔧 <strong>Click to expand configuration details</strong></summary>

### Required Variables
- `aws_region` - AWS region for deployment
- `aws_instance_type` - EC2 instance size
- `aws_key_name` - SSH key pair name
- `vpc_subnet_id` - Target subnet ID
- `aws_security_group` - Security group ID

### Optional Features
- `slack_notifications_enabled` - Enable Slack alerts
- `encrypt_root_volume` - EBS encryption
- `auto_shutdown` - Cost optimization tags
- `backup_required` - Backup scheduling tags

</details>

---

## 🔐 Security Best Practices

> ⚠️ **Important Security Guidelines**

- ✅ **Use IAM roles** instead of hardcoded credentials
- ✅ **Enable EBS encryption** for sensitive workloads
- ✅ **Follow least privilege** for security groups
- ✅ **Use private subnets** for internal instances
- ✅ **Regularly rotate** access keys
- ❌ **Never commit** `vars.yml` with real credentials

---

## 📊 Cost Management

### 💡 Cost Optimization Tips

| Instance Type | Hourly Cost* | Best For |
|---------------|-------------|----------|
| `t3.nano` | ~$0.0052 | Testing/Development |
| `t3.micro` | ~$0.0104 | Small applications |
| `t3.small` | ~$0.0208 | Web servers |
| `t3.medium` | ~$0.0416 | Production workloads |

*Costs may vary by region and are estimates only*

### 🧹 Cleanup Commands
```bash
# List instances created by this tool
aws ec2 describe-instances --filters 'Name=tag:CreatedBy,Values=ansible-ec2-generator'

# Terminate specific instance
aws ec2 terminate-instances --instance-ids i-1234567890abcdef0
```

---

## 🔄 GitHub Actions Workflow

The included GitHub Actions workflow provides:

- 🔍 **Validation** - Syntax and YAML validation
- 🧪 **Testing** - Ansible lint and dry-run testing  
- 🏗️ **Build** - Configuration preparation with artifacts
- 🚀 **Deploy** - Manual deployment with environment protection
- 🧹 **Cleanup** - Automated resource cleanup with manual trigger

### 🎮 How to Use

1. **Automatic Validation**: Triggered on push/PR to main branch
2. **Manual Deployment**: Go to Actions → Run workflow → Check "Deploy EC2 instance"
3. **Manual Cleanup**: Go to Actions → Run workflow → Check "Cleanup AWS resources"

### 🔐 Required Secrets

Add these secrets to your GitHub repository:
- `AWS_ACCESS_KEY_ID` - Your AWS access key
- `AWS_SECRET_ACCESS_KEY` - Your AWS secret key  
- `AWS_REGION` - Target AWS region (optional, defaults to us-east-1)

---

## 👥 Collaborators & Contributors

<div align="center">

| Role | Name | Contribution |
|------|------|-------------|
| 🏗️ **Original Creator** | [pdelpino](https://www.linkedin.com/in/pdelpino/) | Initial concept and basic implementation |
| 🤖 **AI Collaborator** | Igor The Student | Modernization, documentation, CI/CD, security enhancements |
| 🚀 **Automation Lead** | Infrastructure Team | Enterprise-grade features and best practices |

</div>

## 🤝 Contributing

We welcome contributions! Please see our contributing guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 🙏 Credits & Acknowledgments

### 📚 Technical References

- **[Ansible Documentation](https://docs.ansible.com/)** - Official Ansible documentation and best practices
- **[Ansible Playbook Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)** - Structure and organization guidelines
- **[AWS EC2 User Guide](https://docs.aws.amazon.com/ec2/latest/userguide/)** - Complete Amazon EC2 service documentation
- **[AWS EC2 Instance Types](https://aws.amazon.com/ec2/instance-types/)** - Instance specifications and pricing
- **[Ansible AWS Collection](https://docs.ansible.com/ansible/latest/collections/amazon/aws/)** - AWS modules and plugins reference
- **[EC2 Instance Module](https://docs.ansible.com/ansible/latest/collections/amazon/aws/ec2_instance_module.html)** - Modern EC2 instance management
- **[GitLab CI/CD Documentation](https://docs.gitlab.com/ee/ci/)** - CI/CD pipeline implementation guidance
- **[GitLab CI YAML Reference](https://docs.gitlab.com/ee/ci/yaml/)** - Complete CI configuration syntax

### 🔧 Tools & Technologies

- **[Ansible](https://www.ansible.com/)** - Infrastructure automation platform
- **[Ansible Galaxy](https://galaxy.ansible.com/)** - Community hub for Ansible content
- **[Amazon Web Services](https://aws.amazon.com/)** - Cloud computing platform
- **[AWS CLI Documentation](https://docs.aws.amazon.com/cli/)** - Command line interface reference
- **[GitLab CI](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/)** - Continuous integration platform
- **[Python](https://www.python.org/)** - Programming language for AWS SDK
- **[Boto3 Documentation](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)** - AWS SDK for Python
- **[Jinja2 Templates](https://jinja.palletsprojects.com/)** - Template engine used by Ansible

### 🎨 Design Inspiration

- **[Shields.io](https://shields.io/)** - Beautiful badges for README files
- **[Simple Icons](https://simpleicons.org/)** - SVG icons for popular brands
- **[GitHub Readme Stats](https://github.com/anuraghazra/github-readme-stats)** - Dynamic repository statistics
- **[Awesome README](https://github.com/matiassingers/awesome-readme)** - Curated list of awesome READMEs
- **[readme.so](https://readme.so/)** - README template and design patterns
- **[Emoji Cheat Sheet](https://github.com/ikatyang/emoji-cheat-sheet)** - GitHub emoji reference
- **[Markdown Guide](https://www.markdownguide.org/)** - Comprehensive Markdown syntax reference

### 📖 Security & Best Practices

- **[AWS Security Best Practices](https://aws.amazon.com/architecture/security-identity-compliance/)** - Cloud security guidelines
- **[AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)** - Design principles and best practices
- **[AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)** - Identity and access management
- **[Ansible Security](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#security)** - Ansible security best practices
- **[Ansible Vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html)** - Encrypting sensitive data
- **[OWASP](https://owasp.org/)** - Web application security principles
- **[OWASP Top 10](https://owasp.org/www-project-top-ten/)** - Most critical security risks
- **[Center for Internet Security (CIS)](https://www.cisecurity.org/)** - Security configuration benchmarks
- **[CIS AWS Benchmarks](https://www.cisecurity.org/benchmark/amazon_web_services)** - AWS-specific security benchmarks

### 🌟 Community Resources

- **[Ansible Community](https://www.ansible.com/community)** - Community support and contributions
- **[Ansible Community Guide](https://docs.ansible.com/ansible/latest/community/)** - Contributing guidelines
- **[AWS Community](https://aws.amazon.com/developer/community/)** - AWS developer community resources
- **[AWS re:Post](https://repost.aws/)** - AWS community Q&A platform
- **[DevOps Community](https://devops.com/)** - DevOps practices and methodologies
- **[Reddit r/ansible](https://www.reddit.com/r/ansible/)** - Ansible community discussions
- **[Reddit r/aws](https://www.reddit.com/r/aws/)** - AWS community discussions
- **[Infrastructure as Code Patterns](https://www.oreilly.com/library/view/infrastructure-as-code/9781491924334/)** - IaC design patterns

### 🔍 Code Quality & Testing

- **[Ansible Lint](https://ansible-lint.readthedocs.io/en/latest/)** - Ansible playbook linting
- **[Ansible Lint Rules](https://ansible-lint.readthedocs.io/en/latest/default_rules/)** - Complete rule reference
- **[YAML Lint](https://yamllint.readthedocs.io/en/stable/)** - YAML file validation
- **[Bandit](https://bandit.readthedocs.io/en/latest/)** - Python security vulnerability scanning
- **[Safety](https://pypi.org/project/safety/)** - Python dependency vulnerability checking
- **[pytest-ansible](https://github.com/ansible-community/pytest-ansible)** - Testing Ansible with pytest
- **[Molecule](https://molecule.readthedocs.io/en/latest/)** - Ansible role testing framework

### 💰 Cost Management Resources

- **[AWS Pricing Calculator](https://calculator.aws/)** - Estimate AWS service costs
- **[AWS Cost Explorer](https://aws.amazon.com/aws-cost-management/aws-cost-explorer/)** - Analyze spending patterns
- **[AWS Budgets](https://aws.amazon.com/aws-cost-management/aws-budgets/)** - Set custom cost alerts
- **[EC2 Instance Pricing](https://aws.amazon.com/ec2/pricing/)** - Detailed EC2 pricing information
- **[AWS Trusted Advisor](https://aws.amazon.com/support/trusted-advisor/)** - Cost optimization recommendations

### 🎓 Learning Resources

- **[Ansible for DevOps](https://www.ansiblefordevops.com/)** - Comprehensive Ansible guide
- **[AWS Training](https://aws.amazon.com/training/)** - Official AWS learning paths
- **[GitLab Learn](https://about.gitlab.com/learn/)** - GitLab tutorials and guides
- **[Infrastructure as Code Tutorial](https://learn.hashicorp.com/tutorials/terraform/infrastructure-as-code)** - IaC concepts and practices

---

## 📞 Support & Contact

<div align="center">

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/pdelpino/)
[![Issues](https://img.shields.io/badge/Issues-Report%20Bug-red?style=for-the-badge&logo=github)](https://github.com/your-repo/issues)
[![Discussions](https://img.shields.io/badge/Discussions-Ask%20Question-green?style=for-the-badge&logo=github)](https://github.com/your-repo/discussions)

**💝 Gifts, compliments, and chocolates are always welcome!**

</div>

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**⭐ If this project helped you, please give it a star! ⭐**

*Remember to terminate instances when no longer needed to avoid unnecessary AWS charges* 💰

---

*Built with ❤️ by the Infrastructure Automation Team*

</div>
