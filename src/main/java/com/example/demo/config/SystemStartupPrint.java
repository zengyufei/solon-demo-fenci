package com.example.demo.config;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.net.NetUtil;
import cn.hutool.core.thread.ThreadUtil;
import lombok.extern.slf4j.Slf4j;
import org.apdplat.word.WordSegmenter;
import org.apdplat.word.segmentation.Word;
import org.noear.solon.Solon;
import org.noear.solon.SolonProps;
import org.noear.solon.annotation.Component;
import org.noear.solon.core.event.AppLoadEndEvent;
import org.noear.solon.core.event.EventListener;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@Component
public class SystemStartupPrint implements EventListener<AppLoadEndEvent> {

	@Override
	public void onEvent(AppLoadEndEvent event) throws Throwable {

		log.info("启动完毕...");

		ThreadUtil.execute(() -> {
        	WordSegmenter.segWithStopWords("启动完毕...");
		});
		ThreadUtil.execute(() -> {
			final SolonProps cfg = Solon.cfg();
			final String appName = cfg.appName();
			final String env = cfg.env();
			final String contextPath = cfg.get("server.contextPath");
			final String port = cfg.get("server.port");

			List<String> ipList = getIps();

			final StringBuilder stringBuilder = new StringBuilder(
					"\n------------- " + appName + " (" + env + ") 启动成功 --by " + DateUtil.now() + " -------------\n");
			stringBuilder.append("\t主页访问: --\n");
			for (String ip : ipList) {
				stringBuilder.append("\t\t- 访问: http://")
					.append(ip)
					.append(":")
					.append(port)
					.append(contextPath)
					.append("\n");
			}
			System.out.println(stringBuilder);
		});
	}

	private static List<String> getIps() {
		List<String> ipList = new ArrayList<>();
		for (String localIpv4 : NetUtil.localIpv4s()) {
			ipList.add(localIpv4);
		}
		return ipList;
	}

}
