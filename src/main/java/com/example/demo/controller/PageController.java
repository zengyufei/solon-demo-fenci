package com.example.demo.controller;

import org.noear.solon.annotation.Controller;
import org.noear.solon.annotation.Mapping;
import org.noear.solon.core.handle.ModelAndView;

@Controller
public class PageController {

    @Mapping("/page")
    public ModelAndView page() {
        return new ModelAndView("page.ftl");
    }
}
