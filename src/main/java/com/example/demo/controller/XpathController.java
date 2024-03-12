package com.example.demo.controller;

import cn.hutool.core.io.IoUtil;
import cn.hutool.core.util.StrUtil;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Node;
import org.dom4j.io.SAXReader;
import org.noear.solon.annotation.Controller;
import org.noear.solon.annotation.Mapping;
import org.noear.solon.annotation.Post;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Controller
public class XpathController {


    @Post
    @Mapping("/xpath/find")
    public String find(String text, String keyword, String showLabel) throws DocumentException {
        showLabel = StrUtil.blankToDefault(showLabel, "1");
        //1.创建解析器对象
        SAXReader sr = new SAXReader();
        //2.获取文档对象
        Document document = sr.read(StrUtil.getReader(text));
        //3.调用 selectSingleNode() 方法,获取name节点对象
        final List<String> splitTrim = StrUtil.splitTrim(keyword, "\n");
        final List<String> result = new ArrayList<>();
        for (String s : splitTrim) {
             Node node1 = document.selectSingleNode(s);
            if (StrUtil.equals(showLabel, "1")) {
            }
            final String word = node1.getText();
            result.add(word);
        }
        return result.stream().collect(Collectors.joining("\n"));
    }
}
