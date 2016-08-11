# PingSite
一个小工具，用 Shell 输出目标网址的响应时间

利用 curl 命令，并对返回时间超过 1s 的进行标红，显示统计结果。

运行于 Mac / Linux ，在终端输入 
```sh
$ sh ps.sh $url [-T|t [n]]
```

例如：
```sh
$ sh ps.sh www.omooer.com -T 10
```
以上的示例会进行10次测试。如果不指定 `-T` 则只会执行一次，如果不指定 `-T` 后面的数字则会进行无限循环，直到你按下 `CTRL+C` 手动结束。
