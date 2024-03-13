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
            Map<String, List<Integer>> keyWithAverage = new LinkedHashMap<>();
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
            List<String> keysList = bubbleSorter(keyWithAverage);
            BufferedWriter writer = new BufferedWriter(new FileWriter(file));
            for (int i = 0; i < keysList.size(); i++) {
                writer.write(keysList.get(i) + "\n");
            }
            writer.close();
        }
        catch (IOException e){
            e.printStackTrace();
        }
    }

    private static List<String> bubbleSorter(Map<String, List<Integer>> linkedMap){
        List<String> keysList = new ArrayList<>(linkedMap.keySet());
        List<String> copyOfKeys = new ArrayList<>(keysList);
        for (int i = 0; i < keysList.size()-1; i++) {
            for (int j = keysList.size()-1; j > i; j--) {
                String key1 = copyOfKeys.get(j);
                String key2 = copyOfKeys.get(j-1);
                List<Integer> valueForKey1 = linkedMap.get(key1);
                List<Integer> valueForKey2 = linkedMap.get(key2);
                Integer value1 = valueForKey1.get(0);
                Integer value2 = valueForKey2.get(0);
                if (value1 > value2){
                    linkedMap.put(key1, valueForKey2);
                    linkedMap.put(key2, valueForKey1);
                    String temp = keysList.get(j);
                    keysList.set(j, keysList.get(j-1));
                    keysList.set(j - 1, temp);
                }
            }
        }
        return keysList;
    }
}