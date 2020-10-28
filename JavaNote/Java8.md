## 行为参数化

```java
public static List<Apple> filterApples(List<Apple> inventory, ApplePredicate p) {
    // ApplePredicate 是实现方法的接口
    List<Apple> result = new ArrayList<>();
    for (Apple apple : inventory) {
        if (p.test(apple)) {
            result.add(apple);
        }
    }
    return result;
}

List<Apple> inventory = Arrays.asList(
        new Apple(80, "green"),
        new Apple(155, "green"),
        new Apple(120, "red"));

public static <T> void printList(List<T> list) {
    for (T e : list) {
        System.out.println(e);
    }
}

public static<T> List<T> filter(List<T> list, Predicate<T> p){
    List<T> result =  new ArrayList<>();
    for(T e : list){
        if(p.predicte(e)){
            result.add(e);
        }
    }
    return result;
}

@Test
public void test() {
    List<Apple> heavyApples = filterApples(inventory, new ApplePredicate() {
        @Override
        public boolean test(Apple apple) {
            if (apple.getWeight() > 150) return true;
            return false;
        }
    });
    List<Apple> greenApples = filterApples(inventory, new ApplePredicate() {
        @Override
        public boolean test(Apple apple) {
            if (apple.getColor().equals("green")) return true;
            return false;
        }
    });
    printList(heavyApples);
}

@Test
public void TestLambda(){
    List<Apple> redApples = filter(inventory, (Apple apple)->
            "red".equals(apple.getColor()));
    printList(redApples);

}
```

## 函数式接口

函数式接口就是定义了一个抽象方法的接口

## lambda

```java
Arrays.sort(strs, Comparator.reverseOrder());
Arrays.sort(strs, String::compareTo);
```