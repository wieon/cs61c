public class splitAStringBySpace {
    public static void main (String[] args) {
        String str = "Hello I'm your String";
        String[] splited = str.split("\\s+");
        System.out.println(splited.toString());
        }
}
