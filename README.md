# luci-app-adbyby
openwrt adbyby luci support

## 编译说明

* adbyby文件夹放package,luci-app-adbyby文件夹放luci/appliction目录下.

* 如果你的源码是非trunk版，请修改luci-app-adbyby/root/etc/uci-defaults/40_luci-adbyby文件的名称为luci-adbyby.

## 其他说明

* 各架构都适用，本人仅测试了MT7620A，其他架构欢迎测试

* 源码来自：http://www.right.com.cn/forum/forum.php?mod=viewthread&tid=173451&highlight=adbyby

* 其他版本见：https://github.com/1248289414/luci-app-adbyby

* Makefile中对各架构做了判断，自动拷贝文件，如有问题，欢迎 pull request.
