import java.io.*;
import java.util.*;

public class projectOnJava {
    public static void main(String[] args) {
        File file = new File("fileForJavaProject.txt");
        try {
            BufferedReader bufferedReader = new BufferedReader(new FileReader(file));
            bufferedReader.mark(10000);
            int lineAmount = 0;
            while (bufferedReader.readLine() != null) {
                lineAmount++;
            }
            Map<String, List<Integer>> keyWithAverage = new HashMap<>();
            bufferedReader.reset();
            for (int i = 0; i < lineAmount; i++) {
                int value;
                String key = "";
                String nextLine = bufferedReader.readLine();
                boolean someBool = false;
                for (int j = 0; true; j++){
                    if (someBool){
                        value = Integer.parseInt(nextLine.substring(j));
                        break;
                    }
                    if (nextLine.charAt(j) == ' '){
                        someBool = true;
                        continue;
                    }
                    key += nextLine.charAt(j);
                }
                keyWithAverage.computeIfAbsent(key, k -> new ArrayList<>()).add(value);
            }
            System.out.println(Arrays.toString(new Map[]{keyWithAverage}));
            for (Map.Entry<String, List<Integer>> entry : keyWithAverage.entrySet()){
                List<Integer> values = entry.getValue();
                if (values.size() > 1){
                    int sum = 0;
                    for (Integer value : values) {
                        sum += value;
                    }
                    int average = sum/values.size();
                    values.clear();
                    values.add(average);
                }
            }
            System.out.println(Arrays.toString(new Map[]{keyWithAverage}));
        }
        catch (IOException e){
            e.printStackTrace();
        }
    }
}