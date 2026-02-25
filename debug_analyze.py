import subprocess

def run_analysis():
    try:
        result = subprocess.run(['flutter', 'analyze', 'lib/presentation/home/home_screen.dart'], 
                              capture_output=True, text=True)
        with open('analysis_debug.txt', 'w') as f:
            f.write("STDOUT:\n")
            f.write(result.stdout)
            f.write("\nSTDERR:\n")
            f.write(result.stderr)
        print("Analysis completed. Check analysis_debug.txt")
    except Exception as e:
        with open('analysis_debug.txt', 'w') as f:
            f.write(f"Error running analysis: {e}")

if __name__ == "__main__":
    run_analysis()
