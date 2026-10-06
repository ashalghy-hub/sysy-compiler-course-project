param(
    [string]$Repository = 'ashalghy-hub/sysy-compiler-course-project'
)
$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath (Split-Path -Parent $PSScriptRoot)
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw '未找到 GitHub CLI。请使用官方 gh 并完成 gh auth login，或按 docs/GitHub发布.md 使用网页创建。'
}
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw '未找到 Git。' }
gh auth status
if ($LASTEXITCODE -ne 0) { throw '请先执行 gh auth login。' }
$taskStatus = git status --porcelain
if ($LASTEXITCODE -ne 0) { throw '当前目录不是有效 Git 仓库。' }
if ($taskStatus) { throw '请先检查并提交本地改动，再公开发布。' }
$taskRemotes = git remote
if ($taskRemotes -contains 'origin') { throw 'origin 已存在。请检查远程，不自动修改或覆盖。' }
gh repo create $Repository --public --source . --remote origin --push --description '双人协作的 SysY 编译器课程项目：作业要求、预备实验与开发计划'
if ($LASTEXITCODE -ne 0) { throw '创建或推送未成功，请检查 gh 返回信息；不要强制覆盖已有仓库。' }
gh repo view $Repository --json url,visibility,defaultBranchRef
if ($LASTEXITCODE -ne 0) { throw '远程仓库核验失败。' }
git ls-remote origin refs/heads/main
if ($LASTEXITCODE -ne 0) { throw '远程 main 分支核验失败。' }
