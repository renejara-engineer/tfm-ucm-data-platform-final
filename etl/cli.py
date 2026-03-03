import sys

def main() -> None:
    print("CLI manual (pipelines) no disponible en RELEASE DEMO.")
    print("Use la ejecución por API /run_period (deployment/run_demo.sh) o revise etl/cli_monthly.py.")
    if len(sys.argv) > 1:
        print(f"Comando recibido: {sys.argv[1]}")
    sys.exit(2)

if __name__ == "__main__":
    main()