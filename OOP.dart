import 'dart:io';

// Symptom class representing individual symptoms
class Symptom {
  String name;
  String description;

  Symptom(this.name, this.description);

  @override
  String toString() {
    return '$name: $description';
  }
}

// Disease class representing diseases with symptoms and treatment
class Disease {
  String name;
  List<Symptom> symptoms;
  String treatment;

  Disease(this.name, this.symptoms, this.treatment);

  @override
  String toString() {
    String symptomsStr = symptoms.map((symptom) => symptom.name).join(', ');
    return '$name\nSymptoms: $symptomsStr\nTreatment: $treatment';
  }
}

// Function to read diseases and symptoms from a text file
List<Disease> readDiseasesFromFile(String filename) {
  List<Disease> diseases = [];
  try {
    File file = File(filename);
    List<String> lines = file.readAsLinesSync();
    
    String diseaseName = '';
    List<Symptom> symptoms = [];
    String treatment = '';

    for (String line in lines) {
      if (line.startsWith('Disease:')) {
        if (diseaseName.isNotEmpty) {
          diseases.add(Disease(diseaseName, symptoms, treatment));
          symptoms = [];
        }
        diseaseName = line.substring('Disease:'.length).trim();
      } else if (line.startsWith('Symptom:')) {
        String symptomName = line.substring('Symptom:'.length).trim();
        // Fetch description for the symptom
        String description = lines[lines.indexOf(line) + 1];
        symptoms.add(Symptom(symptomName, description));
      } else if (line.startsWith('Treatment:')) {
        treatment = line.substring('Treatment:'.length).trim();
      }
    }

    // Add the last disease read
    if (diseaseName.isNotEmpty) {
      diseases.add(Disease(diseaseName, symptoms, treatment));
    }
  } catch (e) {
    print('Error reading diseases from file: $e');
  }
  return diseases;
}

// Main function to demonstrate diagnosis based on user-input symptoms

 void main() {
  String diseasesFile = 'C:\\Users\\lifew\\Desktop\\Coding\\PLP\\DartFlutter\\ObjectOrientedP\\diseases.txt';

  // Read diseases and symptoms from file
  List<Disease> allDiseases = readDiseasesFromFile(diseasesFile);

  if (allDiseases.isEmpty) {
    print('No diseases found in the file. Exiting.');
    return;
  }

  // Prompt user for symptoms
 // Prompt user for symptoms
List<String> userInputSymptoms = [];

print('Enter symptoms (one per line), or type "done" to finish:');
while (true) {
  String? input = stdin.readLineSync();
  if (input == null) {
    break; // Exit loop if input is null
  }
  input = input.trim(); // Trim the input to remove leading and trailing whitespace
  if (input.toLowerCase() == 'done') {
    break;
  }
  userInputSymptoms.add(input);
}


  // Perform diagnosis
  diagnosePatient(userInputSymptoms, allDiseases);
}

// Function to diagnose patient based on symptoms
void diagnosePatient(List<String> symptoms, List<Disease> allDiseases) {
  print('\nPatient symptoms: $symptoms\n');

  bool diagnosed = false;
  for (Disease disease in allDiseases) {
    bool hasAllSymptoms = true;
    for (String symptomName in symptoms) {
      if (!disease.symptoms.any((symptom) => symptom.name == symptomName)) {
        hasAllSymptoms = false;
        break;
      }
    }
    if (hasAllSymptoms) {
      print('Diagnosis found:');
      print(disease);
      diagnosed = true;
      break;
    }
  }

  if (!diagnosed) {
    print('No specific disease diagnosed based on given symptoms.');
  }
}
