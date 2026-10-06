# 公开 GitHub 仓库发布

建议仓库名：`sysy-compiler-course-project`；账号：`ashalghy-hub`；可见性：public；分支：main。本地已经准备公开文档；原课程资料及临时提取文件被忽略，不会随发布上传。

公开仓库已通过登录后的 GitHub 网页创建：[项目仓库](https://github.com/ashalghy-hub/sysy-compiler-course-project)。初始文档通过 GitHub 连接器发布。以下保留后续命令行协作的配置方法；网页登录不等于本地 Git 命令行已完成登录。

## 配置 GitHub CLI

在官方 GitHub CLI 可用并登录后，项目目录运行：

```powershell
gh auth login
gh auth setup-git
```

完成配置后，用 `git push` 发布后续提交。`scripts/publish-github.ps1` 仅供创建其他新仓库时参考；当前仓库已经存在，不要再次执行新建步骤。可用 `gh repo view` 和 `git ls-remote origin` 确认远端。

## 已完成的网页创建

打开 [创建仓库](https://github.com/new)，选择账号、填写上述仓库名，选 Public。不要初始化远程 README、.gitignore 或 license，避免与本地初始提交分叉。随后在已配置 GitHub Git 登录的终端执行：

```sh
git remote add origin https://github.com/ashalghy-hub/sysy-compiler-course-project.git
git push -u origin main
git ls-remote origin
```

README 已填写真实仓库链接。搭档用户名为 `3769lkj`，由所有者在仓库 Settings → Collaborators 配置协作者访问，双方按 CONTRIBUTING.md 开始工作。当前未发送邀请。
