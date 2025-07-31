# 🚀 Ansible EC2 Instance Generator

<div align="center">

![Ansible](https://img.shields.io/badge/ansible-%231A1918.svg?style=for-the-badge&logo=ansible&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![GitLab CI](https://img.shields.io/badge/gitlab%20ci-%23181717.svg?style=for-the-badge&logo=gitlab&logoColor=white)

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
- 🔔 **Slack Integration** - Optional notifications for team collaboration
- 🔒 **Security First** - Built-in security best practices and encryption
- 🧪 **CI/CD Ready** - Complete GitLab CI pipeline included

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
| 🔄 **CI/CD Pipeline** | ✅ | Complete GitLab CI integration |

---

## 📁 Project Structure

```
ansible-ec2-generator/
├── 📄 ec2-playbook.yml      # Main Ansible playbook
├── 📁 vars/
│   ├── 📄 vars_sample.yml    # Configuration template
│   └── 📄 vars.yml          # Your configuration (create this)
├── 📄 .gitlab-ci.yml        # CI/CD pipeline
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

## 🔄 CI/CD Pipeline

The included GitLab CI pipeline provides:

- 🔍 **Validation** - Syntax and YAML validation
- 🧪 **Testing** - Ansible lint and dry-run testing
- 🔒 **Security** - Credential and vulnerability scanning
- 🚀 **Deployment** - Manual deployment with approval
- 🧹 **Cleanup** - Resource cleanup guidance

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
- **[AWS EC2 User Guide](https://docs.aws.amazon.com/ec2/)** - Amazon EC2 service documentation
- **[Ansible AWS Collection](https://docs.ansible.com/ansible/latest/collections/amazon/aws/)** - AWS modules and plugins
- **[GitLab CI/CD Documentation](https://docs.gitlab.com/ee/ci/)** - CI/CD pipeline implementation guidance

### 🔧 Tools & Technologies

- **[Ansible](https://www.ansible.com/)** - Infrastructure automation platform
- **[Amazon Web Services](https://aws.amazon.com/)** - Cloud computing platform
- **[GitLab CI](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/)** - Continuous integration platform
- **[Python](https://www.python.org/)** - Programming language for AWS SDK

### 🎨 Design Inspiration

- **[Shields.io](https://shields.io/)** - Beautiful badges for README
- **[GitHub Readme Stats](https://github.com/anuraghazra/github-readme-stats)** - Dynamic repository statistics
- **[Awesome README](https://github.com/matiassingers/awesome-readme)** - Curated list of awesome READMEs
- **[readme.so](https://readme.so/)** - README template and design patterns

### 📖 Security & Best Practices

- **[AWS Security Best Practices](https://aws.amazon.com/architecture/security-identity-compliance/)** - Cloud security guidelines
- **[Ansible Security](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#security)** - Ansible security best practices
- **[OWASP](https://owasp.org/)** - Web application security principles
- **[Center for Internet Security (CIS)](https://www.cisecurity.org/)** - Security configuration benchmarks

### 🌟 Community Resources

- **[Ansible Community](https://www.ansible.com/community)** - Community support and contributions
- **[AWS Community](https://aws.amazon.com/developer/community/)** - AWS developer community resources
- **[DevOps Community](https://devops.com/)** - DevOps practices and methodologies
- **[Infrastructure as Code Patterns](https://www.oreilly.com/library/view/infrastructure-as-code/9781491924334/)** - IaC design patterns

### 🔍 Code Quality & Testing

- **[Ansible Lint](https://ansible-lint.readthedocs.io/)** - Ansible playbook linting
- **[YAML Lint](https://yamllint.readthedocs.io/)** - YAML file validation
- **[Bandit](https://bandit.readthedocs.io/)** - Python security vulnerability scanning
- **[Safety](https://pypi.org/project/safety/)** - Python dependency vulnerability checking

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
