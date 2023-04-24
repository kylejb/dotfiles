function Get-Linkables {
    Get-ChildItem -Recurse -Filter '*.symlink'
}
