package com.example.demo.controller;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.NumberUtil;
import cn.hutool.core.util.StrUtil;
import com.example.demo.utils.ResourceChangeNotifier;
import com.example.demo.utils.WordEntity;
import org.apdplat.word.WordSegmenter;
import org.apdplat.word.segmentation.Word;
import org.noear.solon.annotation.Controller;
import org.noear.solon.annotation.Mapping;
import org.noear.solon.annotation.Post;

import java.util.*;

@Controller
public class KeyWordController {


    @Post
    @Mapping("/word/find")
    public String find(String text, String keyword, String showLabel) {
        showLabel = StrUtil.blankToDefault(showLabel, "1");
        final List<String> inputWords = StrUtil.splitTrim(keyword, "\n");
        // 利用split好的inputWords集合，去消费text；
        Map<String, Integer> lastIndexMap = new HashMap<>();
        List<WordEntity> wordEntities = new ArrayList<>();
        for (String inputWord : inputWords) {
            // 先遍历inputWords，第一个inputWord消费text，匹配text是否存在是否包含，如果存在可能多个，则只需要取第一个
            // 第二次遍历inputWords，第二个inputWord消费text，匹配text是否存在是否包含，如果存在可能多个，则只需要取第一个；第一个inputWord的endIndex作为开始，第二个inputWord的beginIndex作为结束，截取中间的内容并放到List<String>
            int startIndex = 0;
            if (lastIndexMap.containsKey(inputWord)) {
                startIndex = lastIndexMap.get(inputWord);
            }
            final int beginIndex = text.indexOf(inputWord, startIndex);
            if (beginIndex > -1) {
                final int wordLen = inputWord.length();
                final int endIndex = beginIndex + wordLen;
                final WordEntity wordEntity = new WordEntity(inputWord, beginIndex, endIndex, -1, wordLen);
                wordEntities.add(wordEntity);
                lastIndexMap.put(inputWord, endIndex);
            }
        }

        wordEntities.sort(Comparator.comparingInt(WordEntity::getBeginPosition));

        StringBuilder sb = new StringBuilder();

        for (int i = 1; i < wordEntities.size(); i++) {
            final WordEntity beforeWordEntity = wordEntities.get(i - 1);
            final WordEntity nextWordEntity = wordEntities.get(i);

            if (StrUtil.equals(showLabel, "1")) {
                sb.append(beforeWordEntity.getWord()).append(" ");
            }
            sb.append(text, beforeWordEntity.getEndPosition(), nextWordEntity.getBeginPosition());
            sb.append("\n");
        }

        return sb.toString();
    }


    @Post
    @Mapping("/word/biBang")
    public Set<String> biBang(String text) {
        List<Word> words = WordSegmenter.segWithStopWords(text);
        Set<String> result = new HashSet<>();
        for (Word word : words) {
            final String wordText = word.getText();
            if (wordText.length() <= 1) {
                continue;
            }
            if (NumberUtil.isNumber(wordText)) {
                continue;
            }
            try {
                DateUtil.parse(wordText);
                continue;
            } catch (Exception ignored) {
            }
            result.add(wordText);
        }
        return result;
    }


    @Post
    @Mapping("/word/add")
    public String add(String word) {
        ResourceChangeNotifier.addDic(word);
        return "add success";
    }

    @Post
    @Mapping("/word/remove")
    public String remove(String word) {
        ResourceChangeNotifier.removeDic(word);
        return "remove success";
    }


//    @Get
//    @Mapping("/word/reload")
//    public String dicReload() {
//		DictionaryFactory.reload();//更改词典路径之后，重新加载词典
//        return "reload success";
//    }

}
