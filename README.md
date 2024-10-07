# 5GCore-k8s-lab

## Introdução

Este repositório foi criado com o objetivo de implementar um laboratório virtual usando o **Free5GC** em um cluster Kubernetes de forma distribuída.

Para facilitar o *deployment* do **Free5GC**, é fornecido um *script* para Vagrant com os principais softwares instalados junto com suas dependências.

Caso o usuário queira usar outra forma de implementar o *cluster*, será fornecido um guia *Passo a Passo* para demais instruções.

### Requisitos:

Os requisitos mínimos para as Máquinas Virtuais (*VM's*), são:

| Recursos | Valores |
| :----: | :----: |
| CPU | 4 *vcores* |
| RAM | 8 Gb |
| OS  | Ubuntu 20.04 (Focal Fossa) |

### Instalação de softwares de apoio

Além do *Vagrantfile*, o usuário tem ao seu alcance um *Makefile* composto dos comandos automatizados para o desenvolvimento do cluster. Assim, digite o comando a seguir para realizar as instalações necessárias:

```
sudo apt-get install -y gcc make vim git curl wget nano 
```

## Preparação do Laboratório

> Caso o usuário escolha essa opção, é necessário a instalação do **Vagrant** e do **VirtualBox**. Para a realização da instalação, de acordo com o sistema operacional do usuário (*Host*), acesse esse [link] e siga as orientações.

### Vagrantfile:

Faça o clone desse repositório:

```
git clone https://github.com/pserpaschiavo/5GCore-k8s-lab.git
cd 5GCore-k8s-lab
mkdir .cluster-join
```

> :warning: **Atenção:** O diretório *.cluster-join* tem o objetivo de salvar os *tokens* de união dos nós do cluster e é obrigatório a sua criação.

O arquivo *Vagrantfile* já está preparado para a implementação de um cluster com dois nós (1 *Master*  + 1 *Worker*) com os requisitos mínimos já informados. Se existir a necessidade de adicionar mais nós no cluster, simplesmente altere os valores no campos indicados abaixo:

> adicionar gif

Agora, digite o comando:

```
vagrant up
```

Aguarde até o final do processo.

Assim que encerrado, digite:

```
kubectl get nodes -o wide
```

> adicionar figura

### Helm3



### CNI's

Como padrão, será usado o *Flannel* devido à sua simplicidade.

```
make setup-flannel
```

Utilize o comando abaixo para verificar se todos os *POD's* estão no estado *Ready*

```
watch kubectl get pods -A
```

Assim que todos os *POD's* estiverem prontos, os nós exibirão a seguinte informação:

> inserir figura

Para finalizar essa etapa, será feita a implementação do **Multus CNI**:

```
make setup-multus
```

Novamente, aguarde o estado dos *POD's* para *Ready*


```
watch kubectl get pods -A
```

### OpenEBS

**OpenEBS** é um componente desenvolvido para automatizar a criação de *Volumes* de acordo com a exigência das aplicações. De maneira resumida, o **OpenEBS** cria um *Persistent Volume - PV* a partir da existência de um *Persistent Volume Claim - PVC*. O **Free5GC** necessita de um *volume* para a criação de um banco de dados **Mongo-DB**. Digite o comando abaixo e aguarde-os ficarem prontos:

```
make setup-ebs
```

## *Deployment* do **Free5GC**

Após todos os *POD's* atingirem o estado de *Ready*, o **Free5GC** será implementado da sguinte maneira:

```
make setup-free5gc
```

Com o comando `watch kubectl get pods -A`, o usuário poderá observar as mudanças no *cluster* ao longo do tempo. Alguns *POD's* serão reiniciados e logo em seguida alcançarão o estado de *Ready*

### *Deployment* do **UERANSIM**



```
make setup-ueransim
```

