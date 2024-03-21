package com.example.demo.controller;

import cn.hutool.core.util.StrUtil;
import cn.hutool.core.util.XmlUtil;
import org.noear.solon.annotation.Controller;
import org.noear.solon.annotation.Mapping;
import org.noear.solon.annotation.Post;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Controller
public class XpathController {


    @Post
    @Mapping("/xpath/find")
    public String find(String text, String keyword, String showLabel) {
        showLabel = StrUtil.blankToDefault(showLabel, "1");
        //1.获取文档对象
        Document document = XmlUtil.readXML(text);
        //3.调用 selectSingleNode() 方法,获取name节点对象
        final List<String> splitTrim = StrUtil.splitTrim(keyword, "\n");
        final List<String> result = new ArrayList<>();
        for (String s : splitTrim) {
            Node node1 = XmlUtil.getNodeByXPath(s, document);
            if (StrUtil.equals(showLabel, "1")) {
            }
            final String word = node1.getTextContent();
            result.add(word);
        }
        return result.stream().collect(Collectors.joining("\n"));
    }
}
