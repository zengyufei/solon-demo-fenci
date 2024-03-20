<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="/base.css"/>
    <!-- Import style -->
    <link rel="stylesheet" href="/index.css"/>
    <!-- Import Vue 3 -->
    <script src="/vue.js"></script>
    <!-- Import component library -->
    <script src="/elementplus.js"></script>
    <script src="/axios.min.js"></script>
    <script src="/request.js"></script>
</head>
<body>
<div id="app" class="demo-tabs">
    <el-dialog
            v-model="显示新增标注词窗口"
            title="新增标注词"
            width="500"
            :before-close="()=>显示新增标注词窗口 = false"
    >
        <div style="margin-top: 5px">
            <div style="display: inline-block;">
                <span>标注词:</span>
            </div>
            <div style="display: inline-block;margin-left: 10px;">
                <el-input
                    v-model="标注词"
                    style="width: 250px"
                    placeholder="输入标注词"
                    clearable
            />
            </div>
        </div>
        <template #footer>
            <div class="dialog-footer">
                <el-button type="primary" @click="新增标注词">确认</el-button>
                <el-button type="primary" @click="显示新增标注词窗口 = false">取消</el-button>
            </div>
        </template>
    </el-dialog>

    <el-dialog
            v-model="显示大爆炸结果"
            title="大爆炸结果"
            width="1100"
            :before-close="()=>显示大爆炸结果 = false"
    >
        <div>
            <el-checkbox-group v-model="选中的大爆炸结果">
                <el-checkbox-button v-for="result in 大爆炸结果" :key="result" :value="result">{{
                        result
                    }}
                </el-checkbox-button>
            </el-checkbox-group>
        </div>
        <template #footer>
            <div class="dialog-footer">
                <el-button @click="替换分词">替换分词</el-button>
                <el-button type="primary" @click="追加分词">追加分词</el-button>
                <el-button type="primary" @click="显示大爆炸结果 = false">取消</el-button>
            </div>
        </template>
    </el-dialog>
    <el-tabs v-model="activeName" class="radius" @tab-click="切换tab">
        <el-tab-pane label="分词测试" name="fenci">
            <div>
                <div style="margin-bottom: 5px">
                    <div style="display: inline-block;">
                        <el-text class="mx-1">测试文本</el-text>
                    </div>
                    <div style="display: inline-block;margin-left: 10px;">
                        <el-button v-loading="loading" @click="大爆炸" type="primary" plain>大爆炸</el-button>
                        <el-button v-loading="loading" @click="()=>显示新增标注词窗口 = true" type="primary" plain>新增标注词</el-button>
                    </div>
                </div>
                <div>
                    <el-input v-model="测试文本控件" style="width: 700px" :autosize="{ minRows: 10, maxRows: 10 }"
                              type="textarea" placeholder="请输入测试文本"/>
                </div>
                <div style="margin-top: 5px">
                    <el-button v-loading="loading" @click="执行" type="primary" plain>进行测试</el-button>
                </div>
            </div>
            <div style="margin-bottom: 15px">
                <div style="float: left;margin-right: 10px;">
                    <div>
                        <el-divider content-position="left">分词</el-divider>
                    </div>
                    <div>
                        <el-input v-model="分词控件" style="width: 200px" :autosize="{ minRows: 10, maxRows: 10 }"
                                  type="textarea" placeholder="请输入分词控件"/>
                    </div>
                    <div style="margin-top: 5px">
                        <span>追加符号:</span>
                        <el-input
                                v-model="追加符号"
                                style="width: 100px"
                                placeholder="输入符号"
                                clearable
                        />
                    </div>
                </div>
                <div style="float: left;">
                    <el-divider direction="vertical"/>
                </div>
                <div style="float: left;">
                    <div>
                        <el-divider content-position="left">结果</el-divider>
                    </div>
                    <div>
                        <el-input v-model="结果控件" style="width: 500px" :autosize="{ minRows: 10, maxRows: 10 }"
                                  type="textarea"/>
                    </div>
                    <div style="margin-top: 5px">
                        <span>输出label:</span>
                        <el-switch v-model="输出label" @change="输出label事件"/>
                    </div>
                </div>
            </div>
            <div style="clear: both;margin-top: 35px">
                <el-row>
                    <el-col :span="6">
                        <el-statistic title="测试文本长度" :value="测试文本控件.length"/>
                    </el-col>
                    <el-col :span="6">
                        <el-statistic title="分词数量" :value="分词控件.split('\n').length"/>
                    </el-col>
                    <el-col :span="6">
                        <el-statistic title="结果数量" :value="结果控件.length"/>
                    </el-col>
                </el-row>
            </div>
            <div class="flex gap-2" style="width: 700px;word-wrap:break-word;margin-top: 15px ">
                <el-tag
                        v-for="(tag,index) in 分词控件.split('\n')"
                        :key="tag + '_' +index"
                        closable
                        :disable-transitions="false"
                        @close="handleClose(tag)"
                        style="margin: 1px 3px 1px 3px"
                >
                    {{ tag }}
                </el-tag>
                <div v-if="inputVisible" style="display: block;margin-top: 5px">
                    <el-input
                            style="width: 200px"

                            ref="InputRef"
                            v-model="inputValue"
                            class="w-20"
                            size="small"
                            @keyup.enter="handleInputConfirm"
                            @blur="handleInputConfirm"
                    ></el-input>
                    <el-button class="button-new-tag" size="small" @click="handleInputConfirm">
                        确定
                    </el-button>
                </div>

                <el-button v-else style="display: block;margin-top: 5px" class="button-new-tag" size="small"
                           @click="showInput">
                    + 新增分词
                </el-button>
            </div>
        </el-tab-pane>
        <el-tab-pane label="xml测试" name="xpath">
            <div>
                <div style="margin-bottom: 5px">
                    <div style="display: inline-block;">
                        <el-text class="mx-1">测试文本</el-text>
                    </div>
                </div>
                <div>
                    <el-input v-model="测试文本控件" style="width: 700px" :autosize="{ minRows: 10, maxRows: 10 }"
                              type="textarea" placeholder="请输入测试文本"/>
                </div>
                <div style="margin-top: 5px">
                    <el-button v-loading="loading" @click="执行" type="primary" plain>进行测试</el-button>
                </div>
            </div>
            <div style="margin-bottom: 15px">
                <div style="float: left;margin-right: 10px;">
                    <div>
                        <el-divider content-position="left">分词</el-divider>
                    </div>
                    <div>
                        <el-input v-model="分词控件" style="width: 400px" :autosize="{ minRows: 10, maxRows: 10 }"
                                  type="textarea" placeholder="请输入xpath"/>
                    </div>
                </div>
                <div style="float: left;">
                    <el-divider direction="vertical"/>
                </div>
                <div style="float: left;">
                    <div>
                        <el-divider content-position="left">结果</el-divider>
                    </div>
                    <div>
                        <el-input v-model="结果控件" style="width: 600px" :autosize="{ minRows: 10, maxRows: 10 }"
                                  type="textarea"/>
                    </div>
                </div>
            </div>
            <div style="clear: both;margin-top: 35px">
                <el-row>
                    <el-col :span="6">
                        <el-statistic title="测试文本长度" :value="测试文本控件.length"/>
                    </el-col>
                    <el-col :span="6">
                        <el-statistic title="分词数量" :value="分词控件.split('\n').length"/>
                    </el-col>
                    <el-col :span="6">
                        <el-statistic title="结果数量" :value="结果控件.length"/>
                    </el-col>
                </el-row>
            </div>
            <div class="flex gap-2" style="width: 1100px;word-wrap:break-word;margin-top: 15px ">
                <el-tag
                        v-for="(tag,index) in 分词控件.split('\n')"
                        :key="tag + '_' +index"
                        closable
                        :disable-transitions="false"
                        @close="handleClose(tag)"
                        style="margin: 1px 3px 1px 3px"
                >
                    {{ tag }}
                </el-tag>
                <div v-if="inputVisible" style="display: block;margin-top: 5px">
                    <el-input
                            style="width: 500px"

                            ref="InputRef"
                            v-model="inputValue"
                            class="w-20"
                            size="small"
                            @keyup.enter="handleInputConfirm"
                            @blur="handleInputConfirm"
                    ></el-input>
                    <el-button class="button-new-tag" size="small" @click="handleInputConfirm">
                        确定
                    </el-button>
                </div>

                <el-button v-else style="display: block;margin-top: 5px" class="button-new-tag" size="small"
                           @click="showInput">
                    + 新增xpath
                </el-button>
            </div>
        </el-tab-pane>
    </el-tabs>

</div>
</body>
</html>

<script>
    const {createApp, nextTick, ref, onMounted} = Vue


    const app = createApp({
        setup() {

            const activeName = ref('fenci')
            const loading = ref(false)

            const 分词测试文本 = '入院次数:1姓名:测试性别:女年龄:58岁科室:眼科(沿江)床号:021住院号:00034534545身份证号码:440102154645647401X患者姓名:测试出生地:-性别:女职业:工人年龄:58岁入院时间:2019年7月17日14时50分婚否:未婚记录时间:2022年10月14日09时52分民族:汉族供史者:本人与患者关系:主诉:测试患者现病史:患者2021年11月9日至12日我院住院，PET-CT检查“18F-FDG全身显像：1.右上肺后段混杂密度结节，实性部分糖代谢增高，考虑周围型肺癌并跨右侧叶间裂胸膜生长累及右肺下叶背段。2.右肺门淋巴结转移待排；左肺门、纵隔多发淋巴结，糖代谢增高，考虑炎性增生。3.右上肺尖段胸膜下实性结节，糖代谢轻微增高，不除外肺癌”。2021-11-12行支气管镜+活检，11-19病理报告为“肺腺癌”，明确诊断为“右上 肺腺癌 （cT3N3M0 IIIC期）”。2021-12-03给予培美曲塞+泉铂+信迪利单抗化疗+免疫治疗，用药后出现骨髓移植、胃肠道反应等不良反应，暂停规律化疗，修养后于2022-01-27在当地医院再次给予“培美曲塞+泉铂+信迪利单抗”化疗+免疫治疗，后再次出现骨髓抑制并肺部感染，经输血、抗感染治疗后好转。考虑不良反应较大，予暂停铂类，于2022-03-17、4-20、5-13、6-8给予“培美曲塞0.8g+信迪利单抗200mg”化疗+免疫治疗，过程顺利，现为求进一步诊治，入住我科。近期患者精神可，无发热，偶有咳嗽，咳少量白痰，无心悸、胸闷、胸痛，无气促、咯血，食欲、睡眠可，大小便正常。近期体重无明显改变。既往史:平素健康状况:一般疾病史:无无/有:传染病史:哮喘过敏史:粉尘过敏有无手术外伤史:无输血史:无平素健康状况：一般\r\n曾患有疾病史：无，近期用药史。\r\n传染病史：哮喘，入院前已行血常规，新冠病毒核酸检测等检查，目前排除新冠病毒感染。\r\n食物或药物过敏史：粉尘过敏\r\n手术外伤史：无\r\n输血史：无。个人史:吸烟史:有嗜酒史:无有/无:预防接种史:不详新冠疫苗接种史（下拉选）:是，已接种第三针原籍出生长大，无外地居住史，无疫区居住史，无疫水、疫源接触史。吸烟史 : 有，嗜酒史 : 无，无冶游史，无放射性物质、毒物接触史。近期长途旅行。否认近14天内到过国外、香港、国内新冠疫情中高风险地区、有病例报告的社区，或者接触过来自这些地方的发热或有呼吸道症状的病人，否认近14天内接触过新型冠状病毒感染的病人，否认近14天内家庭或办公室内出现过2例及以上发热咳嗽的病例。\r\n    预防接种史：不详\r\n    新冠疫苗接种史:是，已接种第三针 婚育史:婚否:月经史:痛经:有不规则流血史:无月经史：，痛经：有，不规则流血史：无家族史:有/无:有/无:家族中相关疾病记载，传染病及遗传病等病史。生命体征:体温:36脉搏:呼吸:收缩压:舒张压:T 36℃ P次/分 R 次/分 BP/  mmHg一般情况:发育:正常营养:肥胖体型:肥胖神志:昏迷体位:强迫面容:肝性面容查体:查体不配合发育正常，营养肥胖，体型肥胖，神志昏迷，强迫体位，肝性面容，查体查体不配合皮肤黏膜其他:皮肤弹性良好，皮肤及粘膜未见黄染，未见淤点及淤斑，未见色素沉着，未见溃疡及瘢痕。无皮下结节或肿块。无蜘蛛痣及肝掌。浅表淋巴结:未触及肿大头部外形:头颅畸形:无眼睑情况:正常结膜症状:正常巩膜:无黄染角膜情况:正常瞳孔外形:等大正圆瞳孔对光反射:灵敏口唇情况:苍白悬雍垂:居中头颅无畸形，眼睑正常，结膜正常，巩膜无黄染，角膜正常，双侧瞳孔等大正圆，对光反射灵敏。耳廓无畸形，外耳道通畅，无异常分泌物，乳突无压痛。鼻无畸形，无异常出血及分泌物，副鼻窦区无压痛。口唇苍白，牙龈无红肿，粘膜无溃疡，伸舌居中，扁桃体无肿大，咽部无充血水肿，软腭及悬雍垂悬居中，发音无异常。颈部:抵抗感:无气管方向:居中颈两侧对称，无颈静脉怒张及颈动脉异常搏动，肝颈静脉回流征阴性。颈软无抵抗，气管居中，甲状腺左右叶未及肿块，不肿大。胸部:胸廓外形:对称呼吸运动:正常肋间隙:对称叩诊音:对称听诊音:对称心:心前区无隆起。心尖搏动位于左锁骨中线第Ⅴ肋间内    厘米。心尖搏动不弥散，触无震颤，无心包摩擦感。叩心界不大。心率    次/分，律整齐，心音有力，A2＞P2，各瓣膜区未闻及病理性杂音，无心包摩擦音及心包叩击音，无周围血管征。奇脉:无无无无无无无  胸廓：对称，两侧正常，呼吸动度两侧一致，肋间隙对称。双侧乳房发育正常。\r\n     肺脏：呼吸节律对称；语颤两侧均等一致，无增强或减弱，无胸膜摩擦感及皮下捻发感。两肺叩对称，肺肝相对浊音界位于右锁骨中线第Ⅴ肋间。肺底缘移动范围   厘米。听诊双肺呼吸音对称，未闻及干湿性啰音及胸膜摩擦音。语音传导无异常。\r\n     心脏：心前区无隆起。心尖搏动位于左锁骨中线第Ⅴ肋间内    厘米。心尖搏动不弥散，触无震颤，无心包摩擦感。叩心界不大。心率    次/分，律整齐，心音有力，A2＞P2，各瓣膜区未闻及病理性杂音，无心包摩擦音及心包叩击音，无周围血管征。\r\n     血管：无奇脉，无水冲脉，无交替脉，无脉搏短绌。周围血管征：无毛细血管搏动征，无射枪音，无动脉异常搏动。腹部:腹部外形正常，无胃型，无肠型及无蠕动波，腹软，无压痛，无反跳痛，无腹部包块，肝脏触诊未触及，胆囊未触及，脾未触及肿大，腹部叩诊呈鼓音，肝区无叩击痛，肾区无叩击痛，移动性浊音呈阴性，听诊肠鸣音正常。脊柱:脊柱无畸形，无侧弯，各椎体无压痛及叩击痛，活动无障碍。四肢情况:无双下肢水肿:双下肢轻度水肿四肢无畸形，活动自如，无杵状指（趾），各关节无红肿，活动无障碍。双下肢轻度水肿，未见静脉曲张，肌肉无萎缩，肌力正常。神经系统:两侧肱二、三头肌反射，膝腱反射及跟腱反射存在，两侧对称，无增强或减弱。双侧Babinski征，Kernig征及Hoffmann征未引出。外阴:女性：阴毛分布正常、外阴发育正常、阴道分泌物正常。专科检查:专科检查测试信息门诊及院外重要辅助检查:本院检验检查结果:有外院检验检查结果:无本院检验检查结果：有。\r\n   外院检验检查结果：无。初步诊断:1.慢性肺源性心脏病\r\n2.血厥病【热伏少阳证】9517980日期:2022年10月14日入院诊断:1.发育性青光眼\r\n2.肝功能检查的异常结果\r\n3.右 咳嗽\r\n*4.(传)痤疮10072814日期:修正诊断:1.慢性肺源性心脏病\r\n2.血厥病【热伏少阳证】9517980日期:2022年10月14日'
            const xpath测试文本 = '<?xml version="1.0" encoding="gb2312"?><Template type="Word"><Binary></Binary><DocObjContent><NewCtrl Id="20130322174753111111" Type="3" CalcText="" CheckboxCaption="" Code="" ConsistenceType="3" ControlID="20130322174753" ControlName="患者姓名" ControlType="3" ControlTypeTemplate="ElementLableAndText" ElementID="201696" ExpandInput="TRUE" ExternalDataSourceId="inpatientName" ExternalDataSourceType="0" IsDefault="TRUE" IsGroupReplace="FALSE" IsGroupUse="FALSE" IsSaveAsNode="FALSE" Reference="FALSE" UpdateFirst="FALSE" UserSet="" WomanUse="FALSE" WordVersion="2" emrCode="EMR02.01.039.0015" platformTemplateType="C0049" Reserve="" EdgeStyle="[" EdgeStyle2="]" Edge="FALSE" DelFlag="TRUE" EditProtect="FALSE" HelpTip="姓名" IsCtrlHidden="FALSE" PlaceHolder="姓名" MustFillContent="FALSE" ViewSecret="FALSE"><Content_Text>测试</Content_Text></NewCtrl><NewCtrl Id="421" Type="6" BetweenInTimeAndOutTime="FALSE" CalcText="" CheckboxCaption="" Code="" ConsistenceType="1" ControlID="42" ControlName="性别" ControlType="1" ControlTypeTemplate="ElementLableAndComboBox" ElementID="42" ExpandInput="FALSE" ExternalDataSourceId="inpatientSex" ExternalDataSourceType="0" FormatConvertClassWord="" IsDefault="TRUE" IsGroupReplace="FALSE" IsGroupUse="FALSE" IsNullPrint="FALSE" IsSaveAsNode="FALSE" Reference="FALSE" ReplaceOldValue="FALSE" SetUCControl="" UpdateEveryTime="FALSE" UpdateFirst="TRUE" UserSet="" WomanUse="FALSE" WordVersion="2" WritingInAdvance="FALSE" emrCode="EMR02.01.040.00" platformTemplateType="C0049" Reserve="20120425114846 男~女" EdgeStyle="[" EdgeStyle2="]" Edge="FALSE" DelFlag="FALSE" EditProtect="FALSE" HelpTip="性别" IsCtrlHidden="FALSE" PlaceHolder="性别" MustFillContent="FALSE" ViewSecret="FALSE" SelectedName="女" SelectedCode="1"><Content_Text>女</Content_Text></NewCtrl><NewCtrl Id="201910281180641" Type="3" BetweenInTimeAndOutTime="FALSE" CalcText="" CheckboxCaption="" Code="PatientAge" ConsistenceType="3" ControlID="20191028118064" ControlName="年龄" ControlType="3" ControlTypeTemplate="ElementLableAndText" ElementID="201701" ExpandInput="TRUE" ExternalDataSourceId="inpatientAge" ExternalDataSourceType="0" FormatConvertClassWord="" IsDefault="TRUE" IsGroupReplace="FALSE" IsGroupUse="FALSE" IsNullPrint="FALSE" IsSaveAsNode="FALSE" Reference="FALSE" ReplaceOldValue="FALSE" SetUCControl="" UpdateEveryTime="FALSE" UserSet="" WomanUse="FALSE" WordVersion="2" WritingInAdvance="FALSE" emrCode="EMR02.01.026.00" Reserve="" EdgeStyle="[" EdgeStyle2="]" Edge="FALSE" DelFlag="TRUE" EditProtect="FALSE" HelpTip="年龄" IsCtrlHidden="FALSE" PlaceHolder="年龄" MustFillContent="FALSE" ViewSecret="FALSE"><Content_Text>58岁</Content_Text></NewCtrl><NewCtrl Id="20130322175248111111" Type="3" CalcText="" CheckboxCaption="" Code="" ConsistenceType="3" ControlID="20130322175248" ControlName="科室" ControlType="3" ControlTypeTemplate="ElementLableAndText" ElementID="211" ExpandInput="TRUE" ExternalDataSourceId="inpatientDeptName" ExternalDataSourceType="0" IsDefault="TRUE" IsGroupReplace="FALSE" IsGroupUse="FALSE" IsSaveAsNode="FALSE" Reference="FALSE" UpdateFirst="FALSE" UserSet="" WomanUse="FALSE" WordVersion="2" emrCode="EMR08.10.026.0009" platformTemplateType="C0049" Reserve="" EdgeStyle="[" EdgeStyle2="]" Edge="FALSE" DelFlag="TRUE" EditProtect="FALSE" HelpTip="科室" IsCtrlHidden="FALSE" PlaceHolder="科室" MustFillContent="FALSE" ViewSecret="FALSE"><Content_Text>眼科(沿江)</Content_Text></NewCtrl><NewCtrl Id="20130322175304111111" Type="3" CalcText="" CheckboxCaption="" Code="" ConsistenceType="3" ControlID="20130322175304" ControlName="床号" ControlType="3" ControlTypeTemplate="ElementLableAndText" ElementID="353" ExpandInput="TRUE" ExternalDataSourceId="inpatientBedNo" ExternalDataSourceType="0" IsDefault="TRUE" IsGroupReplace="FALSE" IsGroupUse="FALSE" IsSaveAsNode="FALSE" Reference="FALSE" UpdateFirst="FALSE" UserSet="" WomanUse="FALSE" WordVersion="2" emrCode="EMR01.00.026.00" platformTemplateType="C0049" Reserve="" EdgeStyle="[" EdgeStyle2="]" Edge="FALSE" DelFlag="TRUE" EditProtect="FALSE" HelpTip="床号" IsCtrlHidden="FALSE" PlaceHolder="床号" MustFillContent="FALSE" ViewSecret="FALSE"><Content_Text>021</Content_Text></NewCtrl><NewCtrl Id="20130322175319111111" Type="3" CalcText="" CheckboxCaption="" Code="" ConsistenceType="3" ControlID="20130322175319" ControlName="住院号" ControlType="3" ControlTypeTemplate="ElementLableAndText" ElementID="358" ExpandInput="TRUE" ExternalDataSourceId="inpatientPatientNo" ExternalDataSourceType="0" IsDefault="TRUE" IsGroupReplace="FALSE" IsGroupUse="FALSE" IsSaveAsNode="FALSE" Reference="FALSE" UpdateFirst="FALSE" UserSet="" WomanUse="FALSE" WordVersion="2" emrCode="EMR01.00.014.00" platformTemplateType="C0049" Reserve="" EdgeStyle="[" EdgeStyle2="]" Edge="FALSE" DelFlag="TRUE" EditProtect="FALSE" HelpTip="住院号" IsCtrlHidden="FALSE" PlaceHolder="住院号" MustFillContent="FALSE" ViewSecret="FALSE"><Content_Text>00034534545</Content_Text></NewCtrl><NewCtrl Id="20220829166246" Type="3" Code="" ConsistenceType="3" ControlID="20220829166246" ControlName="身份证号码" ControlType="3" ControlTypeTemplate="ElementLableAndText" ElementID="390" ExpandInput="True" ExternalDataSourceId="inpatientIdenNo" ExternalDataSourceType="0" IsGroupUse="FALSE" IsSaveAsNode="True" Reference="True" UpdateEveryTime="FALSE" WomanUse="FALSE" WordVersion="2" emrCode="" Reserve="" EdgeStyle="「" EdgeStyle2="」" Edge="FALSE" DelFlag="FALSE" EditProtect="FALSE" HelpTip="身份证号码" IsCtrlHidden="FALSE" PlaceHolder="身份证号码" MustFillContent="FALSE" ViewSecret="FALSE"><Content_Text>440102154645647401X</Content_Text></NewCtrl><NewCtrl Id="201810101148161" Type="11" BetweenInTimeAndOutTime="FALSE" CalcText="" CheckboxCaption="" Code="" ConsistenceType="3" ControlID="20181010114816" ControlName="入院日期" ControlType="8" ControlTypeTemplate="ElementLableAndDateTimePicker" ElementID="1945" ExpandInput="TRUE" ExternalDataSourceId="inpatientInDate" ExternalDataSourceType="0" FormatConvertClassWord="" IsDefault="TRUE" IsGroupReplace="False" IsGroupUse="FALSE" IsNullPrint="FALSE" IsSaveAsNode="TRUE" Reference="False" ReplaceOldValue="FALSE" SetUCControl="" UpdateEveryTime="FALSE" UserSet="" WomanUse="FALSE" WordVersion="2" WritingInAdvance="FALSE" emrCode="EMR06.00.092.00" platformTemplateType="C0049" Reserve="" EdgeStyle="[" EdgeStyle2="]" Edge="TRUE" DelFlag="FALSE" EditProtect="FALSE" HelpTip="入院日期" IsCtrlHidden="FALSE" PlaceHolder="入院日期" MustFillContent="TRUE" ViewSecret="FALSE"><Content_Text AllDate="Date=2019-7-17 Week= Time=14:50:">2019年7月17日</Content_Text></NewCtrl><NewCtrl Id="2018071214513511" Type="11" BetweenInTimeAndOutTime="FALSE" CalcText="" CheckboxCaption="" Code="" ConsistenceType="3" ControlID="20180712145135" ControlName="出院日期" ControlType="8" ControlTypeTemplate="ElementLableAndDateTimePicker" ElementID="375" ExpandInput="TRUE" ExternalDataSourceId="inpatientOutDate" ExternalDataSourceType="0" FormatConvertClassWord="" IsDefault="FALSE" IsGroupReplace="FALSE" IsGroupUse="FALSE" IsNullPrint="FALSE" IsSaveAsNode="TRUE" Reference="False" ReplaceOldValue="FALSE" SetUCControl="" UpdateEveryTime="FALSE" UserSet="" WomanUse="FALSE" WordVersion="2" WritingInAdvance="FALSE" emrCode="EMR06.00.017.00" platformTemplateType="C0049" Reserve="" EdgeStyle="[" EdgeStyle2="]" Edge="TRUE" DelFlag="TRUE" EditProtect="FALSE" HelpTip="出院日期" IsCtrlHidden="FALSE" PlaceHolder="出院日期" MustFillContent="TRUE" ViewSecret="FALSE"><Content_Text AllDate="Date=2022-10-14 Week= Time=0:0:">2022年10月14日</Content_Text></NewCtrl><NewCtrl Id="20180711141095" Type="3" BetweenInTimeAndOutTime="FALSE" CalcText="" CheckboxCaption="" Code="" ConsistenceType="3" ControlID="20180711141095" ControlName="入院情况" ControlType="3" ControlTypeTemplate="ElementLabelAndRichTextBox" ElementID="202719" ExpandInput="TRUE" ExternalDataSourceId="" ExternalDataSourceType="" FormatConvertClassWord="" IsDefault="TRUE" IsGroupReplace="TRUE" IsGroupUse="FALSE" IsNullPrint="FALSE" IsSaveAsNode="TRUE" Reference="FALSE" ReplaceOldValue="FALSE" SetUCControl="" UpdateEveryTime="FALSE" UserSet="" WomanUse="FALSE" WordVersion="2" WritingInAdvance="FALSE" emrCode="EMR05.10.148.00" platformTemplateType="C0049" Reserve="" EdgeStyle="[" EdgeStyle2="]" Edge="TRUE" DelFlag="TRUE" EditProtect="FALSE" HelpTip="入院情况" IsCtrlHidden="FALSE" PlaceHolder="入院情况" MustFillContent="FALSE" ViewSecret="FALSE"><Content_Text></Content_Text></NewCtrl><NewCtrl Id="20190822113160" Type="3" BetweenInTimeAndOutTime="FALSE" CalcText="" CheckboxCaption="" Code="PreliminaryDiagnosis" ConsistenceType="3" ControlID="20190822113160" ControlName="初步诊断" ControlType="3" ControlTypeTemplate="ElementLableAndText" ElementID="215" ExpandInput="TRUE" ExternalDataSourceId="" ExternalDataSourceType="0" FormatConvertClassWord="Neusoft.Emr.Diagnosis.UI,Neusoft.Emr.Diagnosis.UI.Internal.Controls.RealOneInDiagnoseControl" IsDefault="TRUE" IsGroupReplace="FALSE" IsGroupUse="FALSE" IsNullPrint="FALSE" IsSaveAsNode="TRUE" Reference="TRUE" ReplaceOldValue="FALSE" SetUCControl="" UpdateEveryTime="FALSE" UserSet="" WomanUse="FALSE" WordVersion="2" WritingInAdvance="FALSE" emrCode="EMR.admissionDiagnosisList" Reserve="" EdgeStyle="[" EdgeStyle2="]" Edge="TRUE" DelFlag="TRUE" EditProtect="TRUE" HelpTip="初步诊断" IsCtrlHidden="FALSE" PlaceHolder="请双击录入诊断" MustFillContent="FALSE" ViewSecret="FALSE"><Content_Text>高血压3级</Content_Text></NewCtrl><NewCtrl Id="20190528108484" Type="3" BetweenInTimeAndOutTime="FALSE" CalcText="" CheckboxCaption="" Code="" ConsistenceType="3" ControlID="20190528108484" ControlName="诊疗过程描述" ControlType="3" ControlTypeTemplate="ElementText" ElementID="203743" ExpandInput="FALSE" ExternalDataSourceId="" ExternalDataSourceType="" FormatConvertClassWord="" IsDefault="TRUE" IsGroupReplace="TRUE" IsGroupUse="FALSE" IsNullPrint="FALSE" IsSaveAsNode="TRUE" Reference="FALSE" ReplaceOldValue="FALSE" SetUCControl="" UpdateEveryTime="FALSE" UserSet="" WomanUse="FALSE" WordVersion="2" WritingInAdvance="FALSE" emrCode="EMR06.00.296.00" platformTemplateType="C0049" Reserve="" EdgeStyle="[" EdgeStyle2="]" Edge="TRUE" DelFlag="TRUE" EditProtect="FALSE" HelpTip="" IsCtrlHidden="FALSE" PlaceHolder="诊疗过程描述" MustFillContent="FALSE" ViewSecret="FALSE"><Content_Text></Content_Text></NewCtrl><NewCtrl Id="20190715175294" Type="3" BetweenInTimeAndOutTime="FALSE" CalcText="" CheckboxCaption="" Code="" ConsistenceType="0" ControlID="20190715175294" ControlName="病理报告" ControlType="3" ControlTypeTemplate="ElementText" ElementID="204356" ExpandInput="FALSE" ExternalDataSourceId="" ExternalDataSourceType="" FormatConvertClassWord="" IsDefault="TRUE" IsGroupReplace="TRUE" IsGroupUse="FALSE" IsNullPrint="FALSE" IsSaveAsNode="TRUE" Reference="FALSE" ReplaceOldValue="FALSE" SetUCControl="" UpdateEveryTime="FALSE" UserSet="" WomanUse="FALSE" WordVersion="2" WritingInAdvance="FALSE" emrCode="" Reserve="" EdgeStyle="[" EdgeStyle2="]" Edge="TRUE" DelFlag="TRUE" EditProtect="FALSE" HelpTip="病理报告" IsCtrlHidden="FALSE" PlaceHolder="病理报告" MustFillContent="FALSE" ViewSecret="FALSE"><Content_Text></Content_Text></NewCtrl><NewCtrl Id="20190822112673" Type="3" BetweenInTimeAndOutTime="FALSE" CalcText="" CheckboxCaption="" Code="" ConsistenceType="3" ControlID="20190822112673" ControlName="出院诊断" ControlType="3" ControlTypeTemplate="ElementLableAndRichTextBox" ElementID="357" ExpandInput="TRUE" ExternalDataSourceId="" ExternalDataSourceType="0" FormatConvertClassWord="Neusoft.Emr.Diagnosis.UI,Neusoft.Emr.Diagnosis.UI.Internal.Controls.RealOneInDiagnoseControl" IsDefault="TRUE" IsGroupReplace="FALSE" IsGroupUse="FALSE" IsNullPrint="FALSE" IsSaveAsNode="TRUE" Reference="TRUE" ReplaceOldValue="FALSE" SetUCControl="" UpdateEveryTime="FALSE" UserSet="" WomanUse="FALSE" WordVersion="2" WritingInAdvance="FALSE" emrCode="EMR.dischargeOrDeathDiagnosisL" Reserve="" EdgeStyle="[" EdgeStyle2="]" Edge="TRUE" DelFlag="TRUE" EditProtect="TRUE" HelpTip="出院诊断" IsCtrlHidden="FALSE" PlaceHolder="请双击录入诊断" MustFillContent="FALSE" ViewSecret="FALSE"><Content_Text>*1.左上 肺肿物 \r\n2.直肠恶性肿瘤 （术后、化疗后）</Content_Text></NewCtrl><NewCtrl Id="201905281077201" Type="3" BetweenInTimeAndOutTime="FALSE" CalcText="" CheckboxCaption="" Code="" ConsistenceType="3" ControlID="20190528107720" ControlName="出院时症状与体征" ControlType="3" ControlTypeTemplate="ElementText" ElementID="203741" ExpandInput="FALSE" ExternalDataSourceId="" ExternalDataSourceType="" FormatConvertClassWord="" IsDefault="TRUE" IsGroupReplace="TRUE" IsGroupUse="FALSE" IsNullPrint="FALSE" IsSaveAsNode="TRUE" Reference="FALSE" ReplaceOldValue="FALSE" SetUCControl="" UpdateEveryTime="FALSE" UserSet="" WomanUse="FALSE" WordVersion="2" WritingInAdvance="FALSE" emrCode="EMR06.00.193.00" platformTemplateType="C0049" Reserve="" EdgeStyle="[" EdgeStyle2="]" Edge="TRUE" DelFlag="TRUE" EditProtect="FALSE" HelpTip="" IsCtrlHidden="FALSE" PlaceHolder="出院时症状与体征" MustFillContent="FALSE" ViewSecret="FALSE"><Content_Text></Content_Text></NewCtrl><NewCtrl Id="201809252039341" Type="3" BetweenInTimeAndOutTime="FALSE" CalcText="" CheckboxCaption="" Code="In_OutOrder" ConsistenceType="3" ControlID="20180925203934" ControlName="出院医嘱" ControlType="3" ControlTypeTemplate="ElementText" ElementID="369" ExpandInput="TRUE" ExternalDataSourceId="DischargeOrder" ExternalDataSourceType="7" FormatConvertClassWord="" IsDefault="TRUE" IsGroupReplace="FALSE" IsGroupUse="FALSE" IsNullPrint="FALSE" IsSaveAsNode="TRUE" Reference="FALSE" ReplaceOldValue="FALSE" SetUCControl="" UpdateEveryTime="FALSE" UserSet="" WomanUse="FALSE" WordVersion="2" WritingInAdvance="FALSE" emrCode="EMR06.00.287.0001" platformTemplateType="C0049" Reserve="" EdgeStyle="[" EdgeStyle2="]" Edge="TRUE" DelFlag="TRUE" EditProtect="FALSE" HelpTip="出院医嘱" IsCtrlHidden="FALSE" PlaceHolder="出院医嘱" MustFillContent="FALSE" ViewSecret="FALSE"><Content_Text></Content_Text></NewCtrl><Section Id="AllDoctorSignHorizontal2016060115497611" Type="1" ControlName="" ElementID="" IsSaveAsNode="FALSE" Reference="FALSE" UserSet="签名" WomanUse="FALSE" emrCode="EMR02.01.039.0050" platformTemplateType="C0049" Reserve="" EdgeStyle="『" EdgeStyle2="』" Edge="FALSE" DelFlag="TRUE" EditProtect="TRUE" HelpTip="签名" IsCtrlHidden="FALSE" PlaceHolder="签名" MustFillContent="FALSE" ViewSecret="FALSE"><Content_Text></Content_Text></Section><Section Id="AllDoctorSignHorizontal20220825141872" Type="1" UserSet="签名" Reserve="" EdgeStyle="『" EdgeStyle2="』" Edge="FALSE" DelFlag="TRUE" EditProtect="TRUE" HelpTip="签名" IsCtrlHidden="FALSE" PlaceHolder="签名" MustFillContent="FALSE" ViewSecret="FALSE"><Content_Text></Content_Text></Section><Section Id="AllDoctorSignHorizontal20220825148992" Type="1" UserSet="签名" Reserve="" EdgeStyle="『" EdgeStyle2="』" Edge="FALSE" DelFlag="TRUE" EditProtect="TRUE" HelpTip="签名" IsCtrlHidden="FALSE" PlaceHolder="签名" MustFillContent="FALSE" ViewSecret="FALSE"><Content_Text></Content_Text></Section></DocObjContent></Template>'
            const 初始词库 = "床号:\n住院号:\n出生地:\n年龄:\n职业:\n年龄:\n入院时间:\n患者姓名:\n身份证号码:\n姓名:\n性别:\n科室:\n性别:"
            const 初始xpath库 = '/Template/DocObjContent/NewCtrl[\@ControlName="患者姓名"]/../NewCtrl[2]/Content_Text\n/Template/DocObjContent/NewCtrl[\@ControlName="性别"]/Content_Text'

            let 测试文本控件 = ref(分词测试文本)
            let 分词控件 = ref(初始词库)
            let 结果控件 = ref('')
            let 输出label = ref(true)
            const 追加符号 = ref(':')
            const 显示新增标注词窗口 = ref(false)
            const 标注词 = ref('')
            const inputValue = ref('')
            const inputVisible = ref(false)
            const InputRef = ref()
            const 显示大爆炸结果 = ref(false)
            const 大爆炸结果 = ref([])
            const 选中的大爆炸结果 = ref([])

            onMounted(() => {
                // 初始化
                console.log("初始化")
            })

            function 执行(event) {
                loading.value = true;

                let uri
                let data = {}
                if (activeName.value === 'fenci') {
                    uri = '/word/find'
                    data = {
                        "text": 测试文本控件.value,
                        "keyword": 分词控件.value,
                        "showLabel": 输出label.value ? "1" : "0"
                    }
                } else {
                    uri = '/xpath/find'
                    data = {
                        "text": 测试文本控件.value,
                        "keyword": 分词控件.value,
                        "showLabel": 输出label.value ? "1" : "0"
                    }
                }

                post(uri, data).then(res => {
                    console.log(res);
                    结果控件.value = res.data
                    loading.value = false;
                    ElementPlus.ElNotification({
                        message: '请求成功',
                        type: 'success',
                    })
                }).catch(err => {
                    loading.value = false;
                    console.log(err);
                    ElementPlus.ElMessage.error('请求失败:' + err)
                });
            }

            function 大爆炸(event) {
                loading.value = true;

                let uri
                let data = {}
                if (activeName.value === 'fenci') {
                    uri = '/word/biBang'
                    data = {
                        "text": 测试文本控件.value
                    }
                }
                post(uri, data).then(res => {
                    console.log(res);
                    大爆炸结果.value = res.data
                    loading.value = false;
                    显示大爆炸结果.value = true
                    ElementPlus.ElNotification({
                        message: '请求成功',
                        type: 'success',
                    })
                }).catch(err => {
                    loading.value = false;
                    console.log(err);
                    ElementPlus.ElMessage.error('请求失败:' + err)
                });
            }


            function 新增标注词(event) {
                loading.value = true;

                let uri
                let data = {}
                if (activeName.value === 'fenci') {
                    uri = '/word/add'
                    data = {
                        "word": 标注词.value
                    }
                }
                post(uri, data).then(res => {
                    console.log(res);
                    loading.value = false;
                    ElementPlus.ElNotification({
                        message: res.data,
                        type: 'success',
                    })
                }).catch(err => {
                    loading.value = false;
                    console.log(err);
                    ElementPlus.ElMessage.error('请求失败:' + err)
                });
            }

            const 切换tab = (tab, event) => {
                if (activeName.value === 'fenci') {
                    测试文本控件.value = xpath测试文本
                    分词控件.value = 初始xpath库
                } else {
                    测试文本控件.value = 分词测试文本
                    分词控件.value = 初始词库
                }
                结果控件.value = ''
            }

            const handleClose = (tag) => {
                let attr = 分词控件.value.split('\n')
                attr.splice(attr.indexOf(tag), 1)
                分词控件.value = attr.join('\n')
            }

            const showInput = () => {
                inputVisible.value = true
                nextTick(() => {
                    InputRef.value.input.focus()
                })
            }

            const handleInputConfirm = () => {
                let attr = 分词控件.value.split('\n')
                if (inputValue.value) {
                    attr.push(inputValue.value)
                }
                inputVisible.value = false
                inputValue.value = ''
                分词控件.value = attr.join('\n')
            }
            const 输出label事件 = (event) => {
                执行(event)
            }

            function 替换分词(event) {
                console.log(替换分词)
                let attr = []
                选中的大爆炸结果.value.forEach(item => {
                    attr.push(item + 追加符号.value)
                })
                分词控件.value = attr.join('\n')
                选中的大爆炸结果.value = []
                显示大爆炸结果.value = false
            }

            function 追加分词(event) {
                console.log(追加分词)
                let attr = 分词控件.value.split('\n')
                选中的大爆炸结果.value.forEach(item => {
                    attr.push(item + 追加符号.value)
                })
                分词控件.value = attr.join('\n')
                选中的大爆炸结果.value = []
                显示大爆炸结果.value = false
            }

            function 关闭大爆炸(event) {
                显示大爆炸结果.value = false
                大爆炸结果.value = []
                选中的大爆炸结果.value = []
            }

            return {
                activeName,
                loading,
                测试文本控件,
                分词控件,
                结果控件,
                输出label,
                追加符号,
                执行,
                切换tab,
                inputValue,
                handleClose,
                showInput,
                InputRef,
                inputVisible,
                handleInputConfirm,
                输出label事件,
                大爆炸,
                大爆炸结果,
                显示大爆炸结果,
                选中的大爆炸结果,
                替换分词,
                追加分词,
                关闭大爆炸,
                显示新增标注词窗口,
                标注词,
                新增标注词,
            }
        }
    })
    app.use(ElementPlus)
    app.mount('#app')


</script>
