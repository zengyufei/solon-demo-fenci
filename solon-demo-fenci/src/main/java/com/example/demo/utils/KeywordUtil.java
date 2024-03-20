//package com.example.demo.utils;
//
//import cn.hutool.core.io.IoUtil;
//import cn.hutool.core.util.StrUtil;
//import org.wltea.analyzer.cfg.Configuration;
//import org.wltea.analyzer.cfg.DefaultConfig;
//import org.wltea.analyzer.core.IKSegmenter;
//import org.wltea.analyzer.core.Lexeme;
//import org.wltea.analyzer.dic.Dictionary;
//
//import java.io.StringReader;
//import java.util.*;
//
//public class KeywordUtil {
//    static Dictionary dictionary;
//    static Configuration cfg;
//    static List<String> initWords = new ArrayList<>();
//    static List<String> expandWords = new ArrayList<>();
//
//    static {
//        long startTime = System.currentTimeMillis();
//        cfg = DefaultConfig.getInstance();
//        cfg.setUseSmart(true); //设置useSmart标志位 true-智能切分 false-细粒度切分
//        boolean flag = loadDictionaries("keywords.dic");
//        if (!flag) {
//            throw new RuntimeException("读取失败");
//        }
//        Dictionary.initial(cfg);
//        dictionary = Dictionary.getSingleton();
//        dictionary.addWords(initWords);
//        long endTime = System.currentTimeMillis();
//        long timeInterval = endTime - startTime;
//        System.out.println(StrUtil.format("初始化耗时: {}ms", timeInterval));
//    }
//
//    private KeywordUtil() {
//
//    }
//
//    public static void addWords(Collection<String> words) {
//        dictionary.addWords(words);
//        expandWords.addAll(words);
//    }
//
//    public static void clearWords() {
//        dictionary.disableWords(expandWords);
//        expandWords.clear();
//    }
//
//    /**
//     * 加载自定义词典，若无想要添加的词则无需调用，使用默认的词典
//     *
//     * @param filenames
//     * @return
//     */
//    private static boolean loadDictionaries(String... filenames) {
//        try {
//            for (String filename : filenames) {
//                IoUtil.readUtf8Lines(
//                        KeywordUtil.class.getClassLoader().getResourceAsStream(filename),
//                        initWords
//                );
//            }
//            return true;
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
//
//    /**
//     * 提取词语，结果将按频率排序
//     *
//     * @param text 待提取的文本
//     * @return 提取出的词
//     */
//    public static List<WordEntity> extract(String text) {
//        List<WordEntity> result = new ArrayList<>();
//        StringReader reader = new StringReader(text);
//        IKSegmenter ikSegmenter = new IKSegmenter(reader, cfg);
//        Lexeme lex;
//        Map<String, Integer> countMap = new HashMap<>();
//        try {
//            while ((lex = ikSegmenter.next()) != null) {
//                final WordEntity wordEntity = new WordEntity(lex.getLexemeText(),
//                        lex.getBeginPosition(), lex.getEndPosition(),
//                        lex.getLexemeType(), lex.getLength());
//                result.add(wordEntity);
//
//                String word = lex.getLexemeText();
//                countMap.put(word, countMap.getOrDefault(word, 0) + 1);
//            }
//            //根据词出现频率从大到小排序
//            result.sort((w1, w2) -> countMap.get(w2.getWord()) - countMap.get(w1.getWord()));
//            return result;
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return Collections.emptyList();
//    }
//
//    /**
//     * 提取存在于我扩充词典的词
//     *
//     * @return
//     */
//    public static Map<String, List<WordEntity>> getKeywords(String text) {
//        long startTime = System.currentTimeMillis();
//        List<WordEntity> words = extract(text);
//        Map<String, List<WordEntity>> result = new HashMap<>(words.size());
//        for (WordEntity wordEntity : words) {
//            if (expandWords.contains(wordEntity.getWord()) || initWords.contains(wordEntity.getWord())) {
//                List<WordEntity> list;
//                if (result.containsKey(wordEntity.getWord())) {
//                    list = result.get(wordEntity.getWord());
//                } else {
//                    list = new ArrayList<>();
//                    result.put(wordEntity.getWord(), list);
//                }
//                list.add(wordEntity);
//                list.sort(Comparator.comparingInt(WordEntity::getBeginPosition));
//            }
//        }
//        long endTime = System.currentTimeMillis();
//        long timeInterval = endTime - startTime;
//        System.out.println(StrUtil.format("查找词组耗时: {}ms", timeInterval));
//        return result;
//    }
//
//    /**
//     * 提取存在于我扩充词典的词
//     *
//     * @return
//     */
//    public static List<WordEntity> getSortKeywords(String text) {
//        long startTime = System.currentTimeMillis();
//        List<WordEntity> words = extract(text);
//        List<WordEntity> result = new ArrayList<>();
//        for (WordEntity wordEntity : words) {
//            if (expandWords.contains(wordEntity.getWord()) || initWords.contains(wordEntity.getWord())) {
//                result.add(wordEntity);
//            }
//        }
//        result.sort(Comparator.comparingInt(WordEntity::getBeginPosition));
//        long endTime = System.currentTimeMillis();
//        long timeInterval = endTime - startTime;
//        System.out.println(StrUtil.format("查找词组耗时: {}ms", timeInterval));
//        return result;
//    }
//
//    public static void main(String[] args) {
//        String text = "哈哈无花果翠云草酢浆草是什么，。我是帅哥666无花果真好吃还有北沙参穿心莲翠云草，草豆蔻和蝉蜕酢浆草也不错的乌药";
//        KeywordUtil keywordUtil = new KeywordUtil();
//        keywordUtil.addWords(Collections.singleton("北沙参"));
//        Map<String, List<WordEntity>> keywords = keywordUtil.getKeywords(text);
//        keywords.forEach((k, v) -> System.out.println(k + " " + v));
//    }
//}
