JAVA注解
JAVA注解的分类：
1按来源：
1）JDK自带的注解：@Override、@Suppvisewarning、@Deprecated
2）常见第三方注解：如Spring:@Autowired、@Service、@Repository
3）自定义注解
2按照运行机制：
1）源码注解：注解只在源码中出现，编译成.class文件时就不存在了
2）编译时注解：注解在源码和.class文件中都存在，如:@Override、@Suppvisewarning、@Deprecated
3）运行时注解：在运行阶段还起作用，甚至会影响运行逻辑的注解，如：@Autowired

自定义注解的语法要求

~~~java
//ElementType可以有很多类型：CONSTRUCTOR(构造方法声明)、FILED(字段声明)、
//LOCAL_VARIABLE(局部变量声明)、METHOD(方法声明)、PACKAGE(包声明)、PARAMETER(参数声明)、TYPE(类、接口)
@Target({ElementType.METHOD,ElementType.TYPE})
//RUNTIME:运行时存在，可以通过反射获取 CLASS:编译时会记录到class文件中，运行时忽略 RESOURCE:只在源码显示，编译时丢弃
@Retention(RetentionPolicy.RUNTIME)
//@Inherited允许子类继承
@Inherited
//@Documented生成javadoc时会包含注解
@Documented
//使用@interface关键字定义注解
public @interface Table {  
//成员类型是受限的，合法的类型包括基础类型(不包括基础类型的包装类：Integer)、String、class、Annotation、Enumeration
//如果注解只有一个成员，则成员名必须取名为value(),在使用时可以忽略成员名和赋值号(=)
//注解可以没有成员，没有成员的注解称为标识注解
//成员以无参无异常方式声明
    String desc();
    String authod();
    //可以用default为成员指定默认值
    int age() default 18;
}
~~~

注解类

~~~java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface Table {
    String value();
}
~~~

~~~java
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Column {
    String value();
}
~~~

实体类

```java
@Table("department")
public class Department {
    @Column("name")
    private String name;
    @Column("amount")
    private Integer amount;
    @Column("leader")
    private String leader;

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public Integer getAmount() { return amount; }
    public void setAmount(Integer amount) { this.amount = amount; }
    public String getLeader() { return leader; }
    public void setLeader(String leader) { this.leader = leader; }
}
```

测试类

~~~java
public class Test {
    public static void main(String[] args){
        //获取类名
        Department f = new Department();
        f.setAmount(10);
        //获取类名：类+类名即
        Class c = f.getClass();
        System.out.println(c);//class Department
        
        //判断Department类是否有Table的注解
        boolean exists = c.isAnnotationPresent(Table.class);
        System.out.println(exists);//true
        
        //得到Department类关于Table的注解：
        Table t = (Table)c.getAnnotation(Table.class);
        System.out.println(t);//@Table(value=department)
        
        //得到Department类关于Table的注解的value值
        String tableName = t.value();
        System.out.println(tableName);//department
        
        //获取字段名数组：private java.lang.String Department.name。。。
        Field[] fields = c.getDeclaredFields();
        for(Field field : fields){
            //获取Department类的字段名
            System.out.println(field);//private java.lang.Integer Department.amount

            //判断Department类的字段Column是否有Column的注解
            boolean exists1 = field.isAnnotationPresent(Column.class);
            System.out.println(exists1);//true

            //得到Department类的字段关于Column的注解
            Column column = field.getAnnotation(Column.class);
            System.out.println(column);//@Column(value=name)

            //得到Department类的字段关于Column的注解的value值
            String columeName = column.value();
            System.out.println(columeName);//amount

            //得到Department类的字段名
            String fieldName = field.getName();
            System.out.println(fieldName);//amount

            //拼接字段方法名
            String getMethodName = "get"+fieldName.substring(0,1).toUpperCase()+fieldName.substring(1);
            System.out.println(getMethodName);//getAmount

            Object fieldValue = null;
            try {
                //获取类Department的方法：
                Method method = c.getMethod(getMethodName);
                System.out.println(method);  //public java.lang.String Department.getAmount()

                //获取类Department的get方法的字段值
                fieldValue = method.invoke(f);
                System.out.println(fieldValue);//10
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
~~~


