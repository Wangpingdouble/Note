[TOC]

### 1、下载iText组件

```java
iText的官方网址是http://www.lowagie.com/iText
下载jar包：iText-2.1.2u.jar、iTextAsian.jar
```

### 2、输出PDF的基本步骤

~~~Java
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfWriter;
import org.junit.Test;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;

/**
 * Created by wangpingping on 2018/3/29.
 */
public class TestPDF {
    @Test
    public void test01() throws FileNotFoundException, DocumentException {
        String FILE_DIR = "/Users/wangpingping/Desktop/";
        //设置页面大小，如：A4
        Rectangle rect = new Rectangle(PageSize.A4.rotate());
        //设置背景颜色
        rect.setBackgroundColor(BaseColor.BLUE);
        //创建文档：背景颜色：蓝，页面大小：A4
        Document document = new Document(rect);
        //输出为/Users/wangpingping/Desktop/createSamplePDF.pdf文档
        PdfWriter writer = pdfWriter.getInstance(document, new FileOutputStream(FILE_DIR + "createSamplePDF.pdf"));
        //打开文档
        document.open();
        //在PDF中写入文字
        document.add(new Paragraph("Hello world"));
        //关闭文档
        document.close();
    }

}

~~~

总结生成PDF文件的步骤：

(1)创建Document对象

~~~java
Document document = new Document();
~~~

其中，Document有3个构造方法：

~~~java
Document document = new Document();
Document document = new Document(Rectangle pageSize);
Document document = new Document(Rectangle pageSize,int marginLeft,int marginRight,int marginTop,int marginBottom);
~~~

pageSize是纸张类型的大小，通常可以使用Pagesize中的常量来表示，例如PageSize.A4表示A4纸张。 marginLeft,marginRight,marginTop,marginBottom分别是正文距离页边的左、右、上、下的补白大小。

(2)创建书写器(Writer)与document对象关联，通过书写器可以将文档写入磁盘中。

~~~java
PdfWriter writer = PdfWriter.getInstance(document, new 	  FileOutputStream("/Users/wangpingping/Desktop/3.pdf"));
~~~

(3)打开文档

~~~java
document.open();
~~~

(4)写入文档内容

~~~java
document.add(new Paragraph("Hello iText"));
~~~

写入的文档内容可以是多种类型，这里是带格式的文本Paragraph,还可以是Phrase、

Paragraph、Table、Graphic对象等。

(5)关闭文档

~~~java
 document.close();
~~~

###  3、设置pdf文件属性

在打开Document对象写入文件之前，可以设置文档的属性，包括文档的标题、主题、作者、关键字、装订方式、创建者、生产者、创建日期等，方法如下：

~~~java
//设置文档标题
document.addTitle("Title@sample");
//设置文档作者
document.addAuthor("Author@rensanning");
//设置文档主题
document.addSubject("Subject@iText sample");
//设置文档关键字
document.addKeywords("Keywords@iText");
//设置创建者
document.addCreator("Creator@iText");
//设置生产者
document.addProducer("Producer@iText");
//设置创建日期
document.addCreationDate(new Date());
//设置文件夹信息
document.addHeader(String name,String content);
~~~

其中方法addHeader()对于PDF文档无效，addHeader()仅对html文档有效，用于添加文档的头信息。

### 4、插入文本

iText中用文本块(Chunk)、短语(Phrase)和段落(Pharagraph)处理文本：

- 文本块是处理文本的最小单位，有一串带格式(包括字体、颜色、大小)的字符串组成。
- 短语由一个或多个文本块组成，短语也可以设定字体，但对于其中已设定过字体的文本块无效。
- 段落由一个或多个文本块或短语组成，相当于Word文档中的段落概念，同样可以设定段落的字体大小、颜色等属性。另外也可以设定段落的首行缩进、对齐方式(左对齐、右对齐、居中对齐)。

~~~java
//打开文档
document.open();
//创建中文字体
BaseFont baseFont = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
Font chinese = new Font(baseFont, 12, Font.NORMAL);
//在PDF中写入文字
document.add(new Paragraph("Hello world"));
document.add(new Paragraph("Hello world", FontFactory.getFont(FontFactory.COURIER, 12, Font.BOLDITALIC)));
document.add(new Paragraph("你好", chinese));
//关闭文档
document.close();
~~~

除字体外，还可以设置段落的首行缩进等属性，这些方法如下：

~~~java
//设置对齐方式
paragraph.setAlignment(1);//1位居中对齐，2为右对齐，3为左对齐，默认为左对齐
//设置首行缩进
paragraph.setFirstLineIndent(2f);
//设置段前距
paragraph.setSpacingBefore(1);
//设置段后距
paragraph.setSpacingAfter(1);
~~~

### 5、文本的中文处理

默认的iText字体设置不支持中文字体，如果在PDF中使用了中文字符，需要下载亚洲语言字体包iTextAsian.jar。

~~~java
//打开文档
document.open();
//创建中文字体
BaseFont baseFont = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
Font chinese = new Font(baseFont, 12, Font.NORMAL);
//在PDF中写入文字
document.add(new Paragraph("你好", chinese));
//关闭文档
document.close();
~~~

### 6、插入表格

~~~java
//创建中文字体
BaseFont baseFont = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
Font chinese = new Font(baseFont, 12, Font.NORMAL);
PdfPTable tableHeader = new PdfPTable(3);
// 设置表的水平对齐
tableHeader.setHorizontalAlignment(1);
//添加表头
tableHeader.addCell(new PdfPCell(new Paragraph("业务部门", chinese)));
tableHeader.addCell(new PdfPCell(new Paragraph("业务部门", chinese)));
tableHeader.addCell(new PdfPCell(new Paragraph("业务部门", chinese)));
document.open();
document.add(tableHeader);
document.close();
~~~

### 7、插入图像

~~~Java
Document document = new Document();
PdfWriter writer = PdfWriter.getInstance(document, new FileOutputStream("/Users/wangpingping/Desktop/3.pdf"));
//创建图片对象，参数为图片的文件名
Image image = Image.getInstance("/Users/wangpingping/Pictures/桌面壁纸2.jpg");
//缩小到原来的10%
image.scalePercent(10f);
document.open();
document.add(image);
document.close();
~~~





